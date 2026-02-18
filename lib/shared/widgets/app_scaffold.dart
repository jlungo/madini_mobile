import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/theme_provider.dart';
import 'buttons/back_button.dart';

/// Common scaffold used across modules, matching the NGMRIS portal shell.
class AppScaffold extends StatelessWidget {
  /// Optional page-specific title; ignored when [usePortalHeader] is true.
  final String? title;

  /// Page body.
  final Widget body;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// When true, shows the NGMRIS portal header with theme toggle & avatar.
  /// When false, uses [title] directly and hides portal header actions.
  final bool usePortalHeader;

  /// Optional actions for the AppBar.
  final List<Widget>? actions;

  /// When true, shows a back button in the AppBar leading (default true).
  final bool showBackButton;

  /// Route used when back is pressed and there is no route to pop (e.g. /home).
  final String? backButtonFallbackRoute;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.floatingActionButton,
    this.usePortalHeader = true,
    this.actions,
    this.showBackButton = true,
    this.backButtonFallbackRoute = '/home',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayTitle =
        usePortalHeader ? 'NGMRIS PORTAL' : (title ?? 'Madini Mobile');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        leading: showBackButton
            ? AppBackButton(fallbackRoute: backButtonFallbackRoute)
            : null,
        title: Text(
          displayTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: usePortalHeader
            ? [
                IconButton(
                  icon: Icon(
                    context.watch<ThemeProvider>().isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                  ),
                  onPressed: () =>
                      context.read<ThemeProvider>().toggle(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.onPrimary
                        .withValues(alpha: 0.1),
                    child: Text(
                      'N',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ...?actions,
              ]
            : actions,
      ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}

