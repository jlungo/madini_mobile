import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Section item for geosurvey sub-navigation.
class GeosurveySection {
  const GeosurveySection({
    required this.id,
    required this.title,
    required this.route,
    required this.icon,
  });

  final String id;
  final String title;
  final String route;
  final IconData icon;
}

/// All geosurvey sections; default is mapping-activity.
List<GeosurveySection> get geosurveySections => [
      GeosurveySection(
        id: 'mapping-activity',
        title: 'Mapping Activity',
        route: '/geoscientific-survey/mapping-activity',
        icon: Icons.map_outlined,
      ),
      GeosurveySection(
        id: 'deposits',
        title: 'Deposits',
        route: '/geoscientific-survey/deposits',
        icon: Icons.landscape_outlined,
      ),
      GeosurveySection(
        id: 'mines',
        title: 'Mines',
        route: '/geoscientific-survey/mines',
        icon: Icons.diamond_outlined,
      ),
      GeosurveySection(
        id: 'drill-holes',
        title: 'Drill Holes',
        route: '/geoscientific-survey/drill-holes',
        icon: Icons.water_drop_outlined,
      ),
      GeosurveySection(
        id: 'geochemistry',
        title: 'Geochemistry',
        route: '/geoscientific-survey/geochemistry',
        icon: Icons.science_outlined,
      ),
      GeosurveySection(
        id: 'map-viewer',
        title: 'Map Viewer',
        route: '/geoscientific-survey/map-viewer',
        icon: Icons.map_outlined,
      ),
      GeosurveySection(
        id: 'data',
        title: 'Data',
        route: '/geoscientific-survey/data',
        icon: Icons.storage_outlined,
      ),
      GeosurveySection(
        id: 'reports',
        title: 'Reports',
        route: '/geoscientific-survey/reports',
        icon: Icons.description_outlined,
      ),
      GeosurveySection(
        id: 'locations',
        title: 'Locations',
        route: '/geoscientific-survey/locations',
        icon: Icons.location_on_outlined,
      ),
    ];

/// Drawer for geosurvey module; highlights current route and navigates on tap.
class GeosurveyDrawer extends StatelessWidget {
  const GeosurveyDrawer({
    super.key,
    required this.currentLocation,
  });

  final String currentLocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: geosurveySections.map((section) {
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
