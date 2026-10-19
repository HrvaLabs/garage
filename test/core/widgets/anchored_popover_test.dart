import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garage/core/widgets/anchored_popover.dart';
import 'package:garage/core/widgets/garage_bottom_nav.dart';
import 'package:garage/core/widgets/garage_sidebar.dart';
import 'package:garage/core/widgets/page_scaffold.dart';
import 'package:garage/core/widgets/pick_one.dart';
import 'package:garage/core/widgets/pointer_anchor.dart';

import '../../support/pump_screen.dart';

const _options = [PickOption('a', 'Alpha'), PickOption('b', 'Beta')];

String? chosen;
late FocusNode _button;

Future<void> pumpChooser(
  WidgetTester tester, {
  required Offset at,
  Size surface = desktopSurface,
}) async {
  await pumpScreen(
    tester,
    Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: at.dx,
            top: at.dy,
            child: Builder(
              builder: (context) => TextButton(
                focusNode: _button,
                onPressed: () async {
                  chosen = await showPickOne<String>(
                    context,
                    options: _options,
                  );
                },
                child: const Text('choose'),
              ),
            ),
          ),
        ],
      ),
    ),
    surface: surface,
  );
  await tester.pumpAndSettle();
}

Rect popover(WidgetTester tester) =>
    tester.getRect(find.byKey(const Key('anchored-popover')));

/// Opens a small popover on behalf of whatever stands for this function.
Future<void> _act(BuildContext context) => showAnchoredPopover<void>(
  context,
  standIn: _act,
  builder: (context) => const SizedBox(width: 200, height: 120),
);

/// A whole page that holds the keys, as a page's shortcuts do: as tall as the
/// page, and no control to hang anything from. K opens a choice.
Widget _keysOnThePage() => Builder(
  builder: (context) => CallbackShortcuts(
    bindings: {
      const SingleActivator(LogicalKeyboardKey.keyK): () =>
          showPickOne<String>(context, options: _options),
    },
    child: const Focus(autofocus: true, child: SizedBox.expand()),
  ),
);

void main() {
  setUp(() {
    chosen = null;
    PointerAnchor.reset();
    _button = FocusNode(debugLabel: 'choose');
  });
  tearDown(() => _button.dispose());

  testWidgets('hangs from where it was clicked', (tester) async {
    await pumpChooser(tester, at: const Offset(300, 200));
    final click = tester.getCenter(find.text('choose'));

    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();

    expect(popover(tester).topLeft.dx, closeTo(click.dx, 1));
    expect(popover(tester).topLeft.dy, closeTo(click.dy, 1));
  });

  testWidgets('stays inside the window at the bottom right corner', (
    tester,
  ) async {
    await pumpChooser(tester, at: const Offset(1360, 860));
    final click = tester.getCenter(find.text('choose'));

    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();

    expect(popover(tester).right, lessThanOrEqualTo(1440 - 16));
    expect(popover(tester).bottom, lessThanOrEqualTo(900 - 16));
    // Turned back from the corner, as a desktop menu is: it ends where the
    // press was rather than covering it.
    expect(popover(tester).right, closeTo(click.dx, 1));
    expect(popover(tester).bottom, closeTo(click.dy, 1));
  });

  testWidgets('a choice opened from the keyboard hangs from the focused '
      'control', (tester) async {
    await pumpChooser(tester, at: const Offset(300, 200));
    // A press somewhere else first: the keyboard must not reuse it.
    await tester.tapAt(const Offset(900, 600));
    _button.requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    final control = tester.getRect(find.text('choose'));
    expect(popover(tester).top, closeTo(control.bottom, 12));
    expect(popover(tester).left, closeTo(control.left, 12));
  });

  testWidgets('hands back what was picked', (tester) async {
    await pumpChooser(tester, at: const Offset(300, 200));
    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Beta'));
    await tester.pumpAndSettle();

    expect(chosen, 'b');
    expect(find.byKey(const Key('anchored-popover')), findsNothing);
  });

  testWidgets('a click outside puts it away with nothing picked', (
    tester,
  ) async {
    await pumpChooser(tester, at: const Offset(300, 200));
    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(1200, 700));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('anchored-popover')), findsNothing);
    expect(chosen, isNull);
  });

  testWidgets('Escape puts it away with nothing picked', (tester) async {
    await pumpChooser(tester, at: const Offset(300, 200));
    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('anchored-popover')), findsNothing);
    expect(chosen, isNull);
  });

  testWidgets('a screen reader is taken into it, as into the dialog it was', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpChooser(tester, at: const Offset(300, 200));
    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byKey(const Key('anchored-popover'))),
      isSemantics(scopesRoute: true),
    );
    semantics.dispose();
  });

  testWidgets(
    'on Android it names its route as a menu does, so TalkBack says it '
    'opened',
    (tester) async {
      // Unnamed, a choice on a tablet held sideways opened in silence, where
      // the dialog it was and Material's own menus say what they are.
      final semantics = tester.ensureSemantics();
      await pumpChooser(tester, at: const Offset(300, 200));
      await tester.tap(find.text('choose'));
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.byKey(const Key('anchored-popover'))),
        isSemantics(scopesRoute: true, namesRoute: true, label: 'Popup menu'),
      );
      semantics.dispose();
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );

  testWidgets('on iOS it names its route with no label, as a menu does there', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpChooser(tester, at: const Offset(300, 200));
    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byKey(const Key('anchored-popover'))),
      isSemantics(scopesRoute: true, namesRoute: true, label: ''),
    );
    semantics.dispose();
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('a phone keeps the bottom sheet', (tester) async {
    await pumpChooser(
      tester,
      at: const Offset(20, 200),
      surface: const Size(400, 900),
    );
    await tester.tap(find.text('choose'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byKey(const Key('anchored-popover')), findsNothing);
  });

  group('with nothing pressed and no control focused', () {
    testWidgets('a choice from a key is centred over the content pane, clear '
        'of the sidebar', (tester) async {
      // Hung from the corner of what held the focus, a whole page, it sat in
      // the window's bottom left corner over the sidebar.
      await pumpDesktop(
        tester,
        GaragePageScaffold(title: 'Statistics', body: _keysOnThePage()),
        initialLocation: '/stats',
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(900, 600));

      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.pumpAndSettle();

      final pane = tester.getRect(find.byType(PopoverPane));
      expect(popover(tester).center.dx, closeTo(pane.center.dx, 1));
      expect(popover(tester).center.dy, closeTo(pane.center.dy, 1));
      expect(
        popover(tester).left,
        greaterThan(tester.getRect(find.byType(GarageSidebar)).right),
      );
    });

    testWidgets('and on a tab, where the page\'s own scope has the focus', (
      tester,
    ) async {
      late BuildContext page;
      await pumpDesktop(
        tester,
        GarageTabScaffold(
          current: GarageTab.timeline,
          title: 'Timeline',
          body: Builder(
            builder: (context) {
              page = context;
              return const SizedBox.expand();
            },
          ),
        ),
        initialLocation: '/timeline',
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(900, 600));
      // Any key: what opens the choice next is the keyboard, not the press.
      await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);

      expect(FocusManager.instance.primaryFocus, isA<FocusScopeNode>());
      showPickOne<String>(page, options: _options);
      await tester.pumpAndSettle();

      final pane = tester.getRect(find.byType(PopoverPane));
      expect(popover(tester).center.dx, closeTo(pane.center.dx, 1));
      expect(popover(tester).center.dy, closeTo(pane.center.dy, 1));
    });

    testWidgets('a window with no pane centres it in the window', (
      tester,
    ) async {
      late BuildContext page;
      await pumpScreen(
        tester,
        Scaffold(
          body: Builder(
            builder: (context) {
              page = context;
              return const SizedBox.expand();
            },
          ),
        ),
        surface: desktopSurface,
      );
      await tester.pumpAndSettle();

      showPickOne<String>(page, options: _options);
      await tester.pumpAndSettle();

      expect(popover(tester).center.dx, closeTo(1440 / 2, 1));
      expect(popover(tester).center.dy, closeTo(900 / 2, 1));
    });
  });

  group('the control that stands for it', () {
    testWidgets('is where a choice from a key hangs, over the focused '
        'control', (tester) async {
      final other = FocusNode(debugLabel: 'other');
      addTearDown(other.dispose);
      await pumpScreen(
        tester,
        Scaffold(
          body: Stack(
            children: [
              Positioned(
                left: 100,
                top: 100,
                child: Builder(
                  builder: (context) => TextButton(
                    focusNode: other,
                    onPressed: () => _act(context),
                    child: const Text('other'),
                  ),
                ),
              ),
              const Positioned(
                left: 600,
                top: 300,
                child: PopoverStandIn(
                  action: _act,
                  child: Text('stands for it'),
                ),
              ),
            ],
          ),
        ),
        surface: desktopSurface,
      );
      await tester.pumpAndSettle();
      other.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      final standIn = tester.getRect(find.text('stands for it'));
      expect(popover(tester).top, closeTo(standIn.bottom, 1));
      expect(popover(tester).left, closeTo(standIn.left, 1));
    });

    testWidgets('but a press is where it was asked for', (tester) async {
      await pumpScreen(
        tester,
        Scaffold(
          body: Stack(
            children: [
              Positioned(
                left: 100,
                top: 100,
                child: Builder(
                  builder: (context) => TextButton(
                    onPressed: () => _act(context),
                    child: const Text('other'),
                  ),
                ),
              ),
              const Positioned(
                left: 600,
                top: 300,
                child: PopoverStandIn(action: _act, child: Text('stands')),
              ),
            ],
          ),
        ),
        surface: desktopSurface,
      );
      await tester.pumpAndSettle();
      final click = tester.getCenter(find.text('other'));

      await tester.tap(find.text('other'));
      await tester.pumpAndSettle();

      expect(popover(tester).topLeft.dx, closeTo(click.dx, 1));
      expect(popover(tester).topLeft.dy, closeTo(click.dy, 1));
    });

    testWidgets('and a press on it hangs from it, below it, not from the '
        'press', (tester) async {
      await pumpScreen(
        tester,
        Scaffold(
          body: Stack(
            children: [
              Positioned(
                left: 600,
                top: 300,
                child: Builder(
                  builder: (context) => PopoverStandIn(
                    action: _act,
                    child: TextButton(
                      onPressed: () => _act(context),
                      child: const Text('stands for it'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        surface: desktopSurface,
      );
      await tester.pumpAndSettle();
      final control = tester.getRect(find.byType(TextButton));

      await tester.tapAt(control.topLeft + const Offset(20, 8));
      await tester.pumpAndSettle();

      expect(popover(tester).top, closeTo(control.bottom, 1));
      expect(popover(tester).left, closeTo(control.left, 1));
    });

    testWidgets('lends itself only from the page on top', (tester) async {
      // Every page under the one on screen stays built, its top bar's Add
      // included, and the first one found was the bottom page's.
      await pumpScreen(
        tester,
        const Scaffold(
          body: Stack(
            children: [
              Positioned(
                left: 100,
                top: 100,
                child: PopoverStandIn(action: _act, child: Text('under')),
              ),
            ],
          ),
        ),
        surface: desktopSurface,
      );
      await tester.pumpAndSettle();
      late BuildContext top;
      tester
          .state<NavigatorState>(find.byType(Navigator).first)
          .push(
            MaterialPageRoute<void>(
              builder: (context) {
                top = context;
                return const Scaffold(
                  body: Stack(
                    children: [
                      Positioned(
                        left: 600,
                        top: 300,
                        child: PopoverStandIn(
                          action: _act,
                          child: Text('on top'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
      await tester.pumpAndSettle();

      _act(top);
      await tester.pumpAndSettle();

      final onTop = tester.getRect(find.text('on top'));
      expect(popover(tester).top, closeTo(onTop.bottom, 1));
      expect(popover(tester).left, closeTo(onTop.left, 1));
    });
  });

  group('the press itself', () {
    testWidgets('is forgotten by a key in every test, not only the first', (
      tester,
    ) async {
      // A widget test drops every keyboard handler when it ends and keeps
      // the pointer's routes, so an anchor that put its handler in once
      // stopped hearing keys from the second test on.
      PointerAnchor.install();
      HardwareKeyboard.instance.clearState();
      await pumpScreen(tester, const SizedBox(), surface: desktopSurface);
      await tester.tapAt(const Offset(10, 20));
      expect(PointerAnchor.point, const Offset(10, 20));

      await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);

      expect(PointerAnchor.point, isNull);
    });

    testWidgets('is kept through a key nobody pressed', (tester) async {
      // A browser makes up a modifier's press when it finds the key down on
      // a pointer event; nobody turned to the keyboard.
      await pumpScreen(tester, const SizedBox(), surface: desktopSurface);
      await tester.tapAt(const Offset(10, 20));

      HardwareKeyboard.instance.handleKeyEvent(
        const KeyDownEvent(
          physicalKey: PhysicalKeyboardKey.shiftLeft,
          logicalKey: LogicalKeyboardKey.shiftLeft,
          timeStamp: Duration.zero,
          synthesized: true,
        ),
      );
      HardwareKeyboard.instance.handleKeyEvent(
        const KeyUpEvent(
          physicalKey: PhysicalKeyboardKey.shiftLeft,
          logicalKey: LogicalKeyboardKey.shiftLeft,
          timeStamp: Duration.zero,
          synthesized: true,
        ),
      );

      expect(PointerAnchor.point, const Offset(10, 20));
    });

    testWidgets('counts for nothing on the web with the accessibility layer '
        'on', (tester) async {
      // The web build hands a click on anything tappable to the app as an
      // accessibility tap and keeps the press back, so the last press it did
      // pass on was some other one: a field's, or the page's.
      PointerAnchor.web = true;
      addTearDown(() => PointerAnchor.web = kIsWeb);
      await pumpScreen(tester, const SizedBox(), surface: desktopSurface);
      await tester.tapAt(const Offset(10, 20));

      expect(SemanticsBinding.instance.semanticsEnabled, isTrue);
      expect(PointerAnchor.point, isNull);
    });

    testWidgets('but counts on the web with it off', (tester) async {
      PointerAnchor.web = true;
      addTearDown(() => PointerAnchor.web = kIsWeb);
      await pumpScreen(tester, const SizedBox(), surface: desktopSurface);
      await tester.tapAt(const Offset(10, 20));

      expect(SemanticsBinding.instance.semanticsEnabled, isFalse);
      expect(PointerAnchor.point, const Offset(10, 20));
    }, semanticsEnabled: false);

    testWidgets('is recorded on a phone too, which never reads it', (
      tester,
    ) async {
      await pumpScreen(tester, const SizedBox());
      await tester.tapAt(const Offset(10, 20));

      expect(PointerAnchor.point, const Offset(10, 20));
    });
  });
}
