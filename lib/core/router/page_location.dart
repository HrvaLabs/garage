import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// The path of the page [context] is in: `/vehicles/v1/fuel` for a car's fuel
/// log, whether it was gone to or pushed. `/` outside a router, which only a
/// widget test builds.
///
/// Read from the page's own route rather than the router's top, so a page
/// underneath another knows where it is, not where the window is.
///
/// The one page without route state is the one go_router builds for an
/// address nothing matches (the router's `errorBuilder`), and asking for its
/// state throws. While it is shown the router is at that address, so that is
/// where it is. Once something else is gone to, it is still drawn until the
/// new page has arrived, and the router has already moved on; it is then
/// wherever the router is.
String pageLocation(BuildContext context) {
  final router = GoRouter.maybeOf(context);
  if (router == null) {
    return '/';
  }
  final current = router.routerDelegate.currentConfiguration;
  if (current.isError) {
    return current.uri.path;
  }
  try {
    return GoRouterState.of(context).uri.path;
  } on GoError {
    // go_router has no way to ask whether a page has route state other than
    // asking for it: this is its answer that the page leaving has none.
    return current.uri.path;
  }
}
