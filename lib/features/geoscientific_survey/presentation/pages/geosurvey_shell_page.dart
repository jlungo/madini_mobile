import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/geosurvey_drawer.dart';

/// Shell for geosurvey module: drawer with section list and [child] as body.
/// Used with go_router ShellRoute; auth is enforced by parent route guard.
class GeosurveyShellPage extends StatelessWidget {
  const GeosurveyShellPage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(
          _titleForLocation(location),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      drawer: GeosurveyDrawer(currentLocation: location),
      body: SafeArea(child: child),
    );
  }

  static String _titleForLocation(String location) {
    if (location.contains('/mapping-activity') && !location.contains('/mapping/') && !location.contains('/mapping-activity/')) {
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
