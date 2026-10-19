import 'package:flutter/material.dart';
import 'package:garage/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../errors/app_failure.dart';
import '../errors/failure_log.dart';
import '../widgets/async_value_view.dart';
import '../widgets/page_scaffold.dart';

/// What an address no route matches opens: a mistyped web address, a link
/// from an older version, a launcher shortcut that lost its URL. go_router's
/// own page said "Page Not Found" over the raw exception, in English, whatever
/// the app's language.
class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({required this.path, super.key});

  /// The address's path, never its query: a query can carry a token, and the
  /// failure log is what Diagnostics hands over.
  final String path;

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  void initState() {
    super.initState();
    // Once, as a failure: a link or a shortcut the app made itself that lands
    // here is a bug, and the address is what a report needs to name it.
    reportFailure(
      AppFailure(
        kind: AppFailureKind.notFound,
        debugMessage: 'no page at ${widget.path}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GaragePageScaffold(
      title: l10n.notFoundTitle,
      body: Center(
        child: EmptyState(
          message: l10n.notFoundMessage,
          action: FilledButton(
            key: const Key('not-found-home'),
            onPressed: () => context.go('/'),
            child: Text(l10n.notFoundHome),
          ),
        ),
      ),
    );
  }
}
