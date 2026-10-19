import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/page_location.dart';

/// A [DefaultTabController] whose tab is part of the page's address:
/// `/vehicles/v1?tab=costs`, `/company?tab=deadlines` (decision 199).
///
/// Read when the page is built, so a tab can be linked to and reloaded, and
/// followed after that: when the address changes under the page, as the
/// browser's Back changes it, the tabs move to the one it names. A query
/// parameter, as `/stats?tab=costs` already was: `/vehicles/:id/fuel` is the
/// fuel log's address, not a tab's.
///
/// On the web a tab moved to is written to the address, so the address says
/// what is on screen. Nowhere else: Android shows no address, and opens on
/// the tab a link names all the same.
class RoutedTabs extends StatelessWidget {
  const RoutedTabs({
    required this.names,
    required this.child,
    this.initialIndex = 0,
    super.key,
  });

  /// The tabs' names in the address, in the order the tabs are drawn.
  final List<String> names;

  /// The tab to open on when the address names none of [names].
  final int initialIndex;

  final Widget child;

  /// Whether a tab moved to is written to the address: on the web, and in a
  /// test that asks.
  @visibleForTesting
  static bool writesAddress = kIsWeb;

  /// The tab [address] names among [names], or [otherwise] when it names
  /// none of them.
  static int indexIn(List<String> names, Uri address, {int otherwise = 0}) {
    final named = names.indexOf(address.queryParameters['tab'] ?? '');
    return named < 0 ? otherwise : named;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: names.length,
      initialIndex: indexIn(
        names,
        pageAddress(context),
        otherwise: initialIndex,
      ),
      child: _TabAddress(
        names: names,
        initialIndex: initialIndex,
        child: child,
      ),
    );
  }
}

/// Keeps the tabs and the address in step, under the controller it hears.
class _TabAddress extends StatefulWidget {
  const _TabAddress({
    required this.names,
    required this.initialIndex,
    required this.child,
  });

  final List<String> names;
  final int initialIndex;
  final Widget child;

  @override
  State<_TabAddress> createState() => _TabAddressState();
}

class _TabAddressState extends State<_TabAddress> {
  TabController? _controller;

  /// Whether the address has been read yet. The first reading opened the
  /// tabs; only a change after it moves them.
  bool _read = false;

  /// The tab the address named when it was last read. Everything under a
  /// page hears when a menu or a dialog opens over it, and tabs that took
  /// that for the address changing would go back to its tab whenever one
  /// did.
  String? _named;

  /// Whether the address changed while the tabs were moving, to be followed
  /// once they stop.
  bool _followWhenStill = false;

  int _indexIn(Uri address) =>
      RoutedTabs.indexIn(widget.names, address, otherwise: widget.initialIndex);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = DefaultTabController.of(context);
    if (!identical(controller, _controller)) {
      _controller?.removeListener(_moved);
      _controller = controller..addListener(_moved);
    }
    final named = pageAddress(context).queryParameters['tab'];
    if (_read && named == _named) {
      return;
    }
    final changed = _read;
    _read = true;
    _named = named;
    if (changed) {
      _follow();
    }
  }

  /// The address changed under the page, by Back or a link to another tab:
  /// the tabs go to the one it names.
  void _follow() {
    final controller = _controller!;
    if (controller.indexIsChanging) {
      _followWhenStill = true;
      return;
    }
    final wanted = _indexIn(pageAddress(context));
    if (controller.index != wanted) {
      controller.animateTo(wanted);
    }
  }

  void _moved() {
    if (_controller!.indexIsChanging) {
      return;
    }
    if (_followWhenStill) {
      _followWhenStill = false;
      _follow();
      return;
    }
    _write();
  }

  void _write() {
    final router = GoRouter.maybeOf(context);
    if (!RoutedTabs.writesAddress || router == null || !_onTop(router)) {
      return;
    }
    final address = pageAddress(context);
    final index = _controller!.index;
    // Already said. Back to an address without a tab opens the first, and
    // writing its name then would be a new entry over the one Back reached.
    if (_indexIn(address) == index) {
      return;
    }
    final name = widget.names[index];
    _named = name;
    // Replaced rather than pushed: the page keeps its place in the stack and
    // its state, and only its address changes. The browser keeps the address
    // before as an entry of its own, which is how Back returns to that tab.
    router.replace(
      address
          .replace(queryParameters: {...address.queryParameters, 'tab': name})
          .toString(),
    );
  }

  /// Whether this page is the router's top, the page `replace` rewrites.
  ///
  /// A tab is written once the tabs stop moving, and a row tapped meanwhile
  /// can push another page there first. A menu or a dialog over this page
  /// is no page of the router's, and leaves it on top.
  bool _onTop(GoRouter router) {
    try {
      return GoRouterState.of(context).pageKey ==
          router.routerDelegate.currentConfiguration.lastOrNull?.pageKey;
    } on GoError {
      return false;
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_moved);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
