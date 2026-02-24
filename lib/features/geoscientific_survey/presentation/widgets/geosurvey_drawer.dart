import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/security/permissions.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

/// Section item for geosurvey sub-navigation with required permission for visibility.
class GeosurveySection {
  const GeosurveySection({
    required this.id,
    required this.title,
    required this.route,
    required this.icon,
    required this.requiredAnyPermissions,
  });

  final String id;
  final String title;
  final String route;
  final IconData icon;
  /// User must have at least one of these to see this section in the drawer.
  final List<String> requiredAnyPermissions;
}

/// All geosurvey sections with their required permissions (CSV-aligned).
List<GeosurveySection> get geosurveySections => [
      GeosurveySection(
        id: 'mapping-activity',
        title: 'Mapping Activity',
        route: '/geoscientific-survey/mapping-activity',
        icon: Icons.map_outlined,
        requiredAnyPermissions: [GeosurveyPermissions.mappingActivityList],
      ),
      GeosurveySection(
        id: 'deposits',
        title: 'Deposits',
        route: '/geoscientific-survey/deposits',
        icon: Icons.landscape_outlined,
        requiredAnyPermissions: [GeosurveyPermissions.depositList],
      ),
      GeosurveySection(
        id: 'mines',
        title: 'Mines',
        route: '/geoscientific-survey/mines',
        icon: Icons.diamond_outlined,
        requiredAnyPermissions: [GeosurveyPermissions.mineList],
      ),
      GeosurveySection(
        id: 'drill-holes',
        title: 'Drill Holes',
        route: '/geoscientific-survey/drill-holes',
        icon: Icons.water_drop_outlined,
        requiredAnyPermissions: [GeosurveyPermissions.drillHoleList],
      ),
      GeosurveySection(
        id: 'geochemistry',
        title: 'Geochemistry',
        route: '/geoscientific-survey/geochemistry',
        icon: Icons.science_outlined,
        requiredAnyPermissions: [GeosurveyPermissions.geochemistryList],
      ),
      GeosurveySection(
        id: 'map-viewer',
        title: 'Map Viewer',
        route: '/geoscientific-survey/map-viewer',
        icon: Icons.map_outlined,
        requiredAnyPermissions: [GeosurveyPermissions.mapViewerView],
      ),
      GeosurveySection(
        id: 'data',
        title: 'Data',
        route: '/geoscientific-survey/data',
        icon: Icons.storage_outlined,
        requiredAnyPermissions: [GeosurveyPermissions.geochemistryList],
      ),
      GeosurveySection(
        id: 'reports',
        title: 'Reports',
        route: '/geoscientific-survey/reports',
        icon: Icons.description_outlined,
        requiredAnyPermissions: [GeosurveyPermissions.reportList],
      ),
      GeosurveySection(
        id: 'locations',
        title: 'Locations',
        route: '/geoscientific-survey/locations',
        icon: Icons.location_on_outlined,
        requiredAnyPermissions: [GeosurveyPermissions.locationList],
      ),
    ];

/// Drawer for geosurvey module; shows only sections the user has permission for.
class GeosurveyDrawer extends StatelessWidget {
  const GeosurveyDrawer({
    super.key,
    required this.currentLocation,
  });

  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<AuthProvider>().user;
    final visibleSections = user == null
        ? <GeosurveySection>[]
        : geosurveySections
            .where((s) => user.hasAnyPermission(s.requiredAnyPermissions))
            .toList();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Geoscientific Survey',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: visibleSections.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          "You don't have access to any geosurvey sections.",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: visibleSections.map((section) {
                        final selected = currentLocation == section.route ||
                            currentLocation.startsWith('${section.route}/');
                        return ListTile(
                          leading: Icon(
                            section.icon,
                            size: 22,
                            color: selected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          title: Text(
                            section.title,
                            style: TextStyle(
                              fontWeight: selected ? FontWeight.w600 : null,
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          selected: selected,
                          onTap: () {
                            Navigator.of(context).pop();
                            if (!selected) context.go(section.route);
                          },
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
