import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/geosurvey_drawer.dart';

/// Shell for geosurvey module: drawer with section list and [child] as body.
/// Used with go_router ShellRoute; auth is enforced by parent route guard.
class GeosurveyShellPage extends StatelessWidget {
  const GeosurveyShellPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // Builder provides a context that is *inside* the Scaffold, which is
        // required for Scaffold.of(ctx) to find this Scaffold correctly.
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          _titleForLocation(location),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      drawer: GeosurveyDrawer(currentLocation: location),
      body: child,
    );
  }

  static String _titleForLocation(String location) {
    if (location.contains('/mapping-activity') &&
        !location.contains('/mapping/') &&
        !location.contains('/mapping-activity/')) {
      return 'Mapping Activity';
    }
    if (location.contains('/deposits')) return 'Deposits';
    if (location.contains('/mines')) return 'Mines';
    if (location.contains('/drill-holes')) return 'Drill Holes';
    if (location.contains('/geochemistry')) return 'Geochemistry';
    if (location.contains('/map-viewer')) return 'Map Viewer';
    if (location.contains('/data')) return 'Data';
    if (location.contains('/reports')) return 'Reports';
    if (location.contains('/locations')) return 'Locations';
    return 'Geoscientific Survey';
  }
}
