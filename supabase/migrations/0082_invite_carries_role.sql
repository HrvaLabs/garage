-- The role a joiner gets travels on the invite code.
--
-- Decided by the owner on 20 September 2026. Every code made a member, and
-- in a company garage a member sees every car, every cost and every other
-- member: the wrong default for somebody hired to drive one van, and
-- "Make driver" afterwards left that open until an admin remembered. A code
-- now says what the joiner becomes, and the join applies it.
alter table public.invites
  add column role text not null default 'member'
    check (role in ('member', 'driver'));

-- create_invite takes the role. Dropped and created again rather than
-- replaced: a third parameter is a new signature, and two overloads that both
-- accept the old call leave PostgREST unable to choose (decision 113). The
-- default keeps that call, which every installed build makes, minting a
-- member's code.
drop function public.create_invite(uuid, text);

create function public.create_invite(
  target_household uuid,
  invite_email text default null,
  invite_role text default 'member'
)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  new_code text;
  attempts int := 0;
begin
  if target_household not in (select public.user_household_ids()) then
    raise exception 'not a member of this household';
  end if;
  if invite_role is null or invite_role not in ('member', 'driver') then
    raise exception 'an invite makes a member or a driver'
      using errcode = '22023';
  end if;
  -- A driver is the admin's to make, on the plan, as "Make driver" is (0080).
  if invite_role = 'driver' and not (
    public.is_household_admin(target_household)
    and public.company_enabled(target_household)
  ) then
    raise exception 'only an admin of a garage on the company plan invites a driver'
      using errcode = '42501';
  end if;

  loop
    new_code := public.generate_invite_code();
    exit when not exists (select 1 from public.invites where code = new_code);
    attempts := attempts + 1;
    if attempts > 10 then
      raise exception 'could not allocate an invite code';
    end if;
  end loop;

  insert into public.invites (
    household_id, code, email, expires_at, created_by, role
  )
  values (
    target_household,
    new_code,
    nullif(trim(invite_email), ''),
    now() + interval '14 days',
    (select auth.uid()),
    invite_role
  );

  return new_code;
end;
$$;

revoke execute on function public.create_invite(uuid, text, text)
  from public, anon;
grant execute on function public.create_invite(uuid, text, text)
  to authenticated;

-- The join applies it. A driver's code waits while the plan has lapsed, as a
-- new driver does (0080): joining as a member instead would hand the whole
-- garage to somebody it meant to give one car. The code is not used up, so
-- it works again once the plan is renewed and before it expires. Otherwise
-- 0010's function.
create or replace function public.join_household_with_code(invite_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  invite public.invites;
  caller uuid := (select auth.uid());
  joined boolean;
begin
  if caller is null then
    raise exception 'authentication required';
  end if;

  select * into invite
  from public.invites
  where code = upper(trim(invite_code))
  for update;

  if invite is null then
    raise exception 'invalid invite code' using errcode = 'P0002';
  end if;
  if invite.expires_at < now() then
    raise exception 'invite code has expired' using errcode = 'P0003';
  end if;
  if invite.redeemed_at is not null then
    raise exception 'invite code has already been used' using errcode = 'P0004';
  end if;
  if invite.role = 'driver'
     and not public.company_enabled(invite.household_id) then
    raise exception 'a driver''s code waits for the company plan'
      using errcode = 'P0009';
  end if;

  insert into public.household_members (household_id, user_id, role)
  values (invite.household_id, caller, invite.role)
  on conflict (household_id, user_id) do nothing;
  joined := found;

  if joined then
    update public.invites
    set redeemed_at = now(), redeemed_by = caller
    where id = invite.id;
  end if;

  return invite.household_id;
end;
$$;
