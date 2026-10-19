-- A driver's service completes the one-off reminder it covers.
--
-- Saving a service completes the one-off rules for the types it covers, after
-- the entry has landed (`completeOneTimeRules` in the app). A driver held no
-- write on `reminder_rules`, so the update was filtered to nothing: the
-- service was saved and the reminder stayed open until an admin logged the
-- same service or completed it by hand.
--
-- The policy reaches an open one-off rule on a car the driver has today, and
-- only when a service of the driver's own, logged since the rule was set,
-- covers its type. "Since" because a service done before a reminder existed
-- did not answer it. "Of their own" because the cost sheet makes the same
-- call when a vignette or a registration is paid, before it writes next
-- year's reminder, and that insert is refused to a driver: completing the old
-- one there would leave the garage with neither, where today the old one
-- stays open for the admin to see.
create policy reminder_rules_update_driver on public.reminder_rules
  for update to authenticated
  using (
    vehicle_id in (select public.driver_vehicle_ids())
    and one_time
    and active
    and exists (
      select 1 from public.service_entries s
      where s.vehicle_id = reminder_rules.vehicle_id
        and s.created_by = (select auth.uid())
        and reminder_rules.service_type_key = any (s.service_type_keys)
        and s.created_at >= reminder_rules.created_at
    )
  )
  with check (
    vehicle_id in (select public.driver_vehicle_ids())
    and one_time
    and not active
  );

-- A policy sees the new row, not what changed, so a driver completing a rule
-- could rewrite its date or its type in the same update. Completing is all
-- the policy is for: the guard lets a driver change `active` and nothing else.
-- Members, the admin among them, edit the intervals as they always have, and
-- a write with no caller, the server's, is let through.
create function public.guard_reminder_rule_driver_update()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if (select auth.uid()) is null
     or old.vehicle_id in (select public.user_vehicle_ids()) then
    return new;
  end if;
  if (to_jsonb(new) - 'active') is distinct from (to_jsonb(old) - 'active') then
    raise exception 'a driver completes a reminder and changes nothing else'
      using errcode = '42501';
  end if;
  return new;
end;
$$;

revoke execute on function public.guard_reminder_rule_driver_update()
  from public, anon, authenticated;

create trigger reminder_rules_guard_driver_update
  before update on public.reminder_rules
  for each row execute function public.guard_reminder_rule_driver_update();
