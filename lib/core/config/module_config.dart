import 'package:flutter/material.dart';

@immutable
class ModuleConfig {
  final String id;
  final String title;
  final String description;
  final String route;
  final IconData icon;

  const ModuleConfig({
    required this.id,
    required this.title,
    required this.description,
    required this.route,
    required this.icon,
  });
}

/// Static module list mirroring the webapp switchboard.
const List<ModuleConfig> kModules = <ModuleConfig>[
  ModuleConfig(
    id: 'dashboard',
    title: 'Dashboard',
    description: 'Overview of system activities and key metrics',
    route: '/dashboard',
    icon: Icons.dashboard_outlined,
  ),
  ModuleConfig(
    id: 'datashop',
    title: 'Data Shop',
    description: 'Explore and manage data assets and datasets',
    route: '/datashop',
    icon: Icons.storage_outlined,
  ),
  ModuleConfig(
    id: 'geoscientific-survey',
    title: 'Geoscientific Survey',
    description: 'Explore and manage mineral resources',
    route: '/geoscientific-survey',
    icon: Icons.terrain_outlined,
  ),
  ModuleConfig(
    id: 'laboratory',
    title: 'Laboratory',
    description: 'Laboratory services and analyses',
    route: '/laboratory',
    icon: Icons.science_outlined,
  ),
];

