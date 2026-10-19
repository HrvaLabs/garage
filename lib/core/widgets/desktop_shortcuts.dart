import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage/l10n/app_localizations.dart';

import '../../features/dashboard/quick_add.dart';
import '../../features/vehicles/providers/vehicle_providers.dart';
import '../theme/garage_theme.dart';
import '../theme/garage_tokens.dart';
import 'confirm_delete.dart';

/// The search field of the page on top, which `/` puts the cursor in on a
/// desk, or null when that page has none.
///
/// A page under the one on top stays built, and its search with it: Vehicles
/// under a car's page. Only a field on the page on top counts, so `/` never
/// sends the cursor into one nobody can see.
FocusNode? get pageSearchFocus {
  for (final target in _SearchShortcutTargetState._onScreen.toList().reversed) {
    if (target._route?.isCurrent ?? true) {
      return target._node;
    }
  }
  return null;
}

/// A page's search field, which `/` puts the cursor in on a desk.
///
/// The same widget at every width: on a phone it hands the field its focus
/// and nothing reads it.
class SearchShortcutTarget extends StatefulWidget {
  const SearchShortcutTarget({
    required this.builder,
    this.focusNode,
    super.key,
  });

  /// Builds the field with the focus `/` moves to.
  final Widget Function(BuildContext context, FocusNode focusNode) builder;

  /// The field's own focus, when it already has one.
  final FocusNode? focusNode;

  @override
  State<SearchShortcutTarget> createState() => _SearchShortcutTargetState();
}

class _SearchShortcutTargetState extends State<SearchShortcutTarget> {
  static final _onScreen = <_SearchShortcutTargetState>{};

  FocusNode? _own;
  ModalRoute<Object?>? _route;

  FocusNode get _node =>
      widget.focusNode ?? (_own ??= FocusNode(debugLabel: 'page search'));

  @override
  void initState() {
    super.initState();
    _onScreen.add(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route = ModalRoute.of(context);
  }

  @override
  void dispose() {
    _onScreen.remove(this);
    _own?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _node);
}

/// `/` to search the page, `n` to add, `?` for the list of them, on a desk;
/// Escape, which closes a dialog or a menu, is the framework's own (decision
/// 199).
///
/// Both scaffolds put it around a page in the shape a wide window alone has,
/// so a phone has none of it. It is told of every key nothing that has the
/// focus took (`FocusManager.addLateKeyEventHandler`), and acts only while
/// its page is on top: a dialog, a popover, a sheet or a menu is a route over
/// the page, and a key pressed in one is not the page's. Nothing on the page
/// has to hold the focus for it, so a click away from a field, which leaves
/// the focus with the route, loses no key; and it adds no focus of its own,
/// for Tab to stop at or be kept in. Told before the focus, as a keyboard
/// handler is, it would act on a key a control on the page also acts on.
///
/// A key typed into a field is the field's: with the focus in an
/// `EditableText` the key goes on, so a `/` in a note stays a `/`. A key held
/// with Ctrl, ⌘ or Alt is the system's. A key it acts on it keeps, so the
/// browser does not type it as well.
class DesktopShortcuts extends ConsumerStatefulWidget {
  const DesktopShortcuts({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<DesktopShortcuts> createState() => _DesktopShortcutsState();
}

class _DesktopShortcutsState extends ConsumerState<DesktopShortcuts> {
  /// The key the shortcuts last acted on. Every page's are told of the key,
  /// and two under one route would otherwise both act on it.
  static KeyEvent? _actedOn;

  ModalRoute<Object?>? _route;

  /// Where the keys are heard, kept so they are let go of there too.
  final _focus = FocusManager.instance;

  @override
  void initState() {
    super.initState();
    _focus.addLateKeyEventHandler(_onKey);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route = ModalRoute.of(context);
  }

  @override
  void dispose() {
    _focus.removeLateKeyEventHandler(_onKey);
    super.dispose();
  }

  KeyEventResult _onKey(KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.synthesized ||
        identical(event, _actedOn) ||
        !(_route?.isCurrent ?? false) ||
        _held() ||
        _inAField()) {
      return KeyEventResult.ignored;
    }
    // Lower case, so an N typed with Caps Lock on is `n`; the list shows N.
    final act = switch (event.character?.toLowerCase()) {
      '/' => pageSearchFocus?.requestFocus,
      'n' => _quickAdd(),
      '?' => () => showShortcutsList(context),
      _ => null,
    };
    if (act == null) {
      return KeyEventResult.ignored;
    }
    _actedOn = event;
    act();
    return KeyEventResult.handled;
  }

  /// The quick-add, from the top bar's Add, which stands for it, as Add's own
  /// press opens it (`showQuickAdd`, decision 199). Only with cars to add to:
  /// while they are read, when the read failed, or with none, there is none,
  /// and the key goes on rather than throw the read's error.
  VoidCallback? _quickAdd() {
    final cars = ref.read(vehiclesProvider);
    if (cars.hasError || !(cars.value?.isNotEmpty ?? false)) {
      return null;
    }
    return () => showQuickAdd(context, ref);
  }

  static bool _held() {
    final keys = HardwareKeyboard.instance;
    return keys.isControlPressed || keys.isMetaPressed || keys.isAltPressed;
  }

  static bool _inAField() {
    final focused = FocusManager.instance.primaryFocus?.context;
    return focused != null &&
        (focused.widget is EditableText ||
            focused.findAncestorWidgetOfExactType<EditableText>() != null);
  }

  @override
  Widget build(BuildContext context) {
    // Watched, as Add watches them, so the cars are read by the time `n`
    // asks: on a page with no Add nothing else may have read them.
    ref.watch(vehiclesProvider);
    return widget.child;
  }
}

/// What the keys do, under `?`.
Future<void> showShortcutsList(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final keyStyle = GarageTheme.numeric(Theme.of(context).textTheme.bodyMedium!);
  Widget row(String key, String does) => Padding(
    padding: const EdgeInsets.symmetric(vertical: GarageTokens.space1),
    child: Row(
      children: [
        SizedBox(width: 56, child: Text(key, style: keyStyle)),
        Expanded(child: Text(does)),
      ],
    ),
  );
  return showNotice(
    context,
    title: l10n.shortcutsTitle,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        row('/', l10n.shortcutsSearch),
        row('N', l10n.shortcutsQuickAdd),
        row('?', l10n.shortcutsHelp),
        row('Esc', l10n.shortcutsClose),
      ],
    ),
  );
}
