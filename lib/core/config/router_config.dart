import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/app_scaffold.dart';
import '../../features/home/presentation/pages/switchboard_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/datashop/presentation/pages/datashop_page.dart';
import '../../features/geoscientific_survey/presentation/pages/geoscientific_mapping_list_page.dart';
import '../../features/geoscientific_survey/presentation/pages/geoscientific_mapping_create_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Basic router configuration with splash and module routes.
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const _SplashPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const SwitchboardPage(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/datashop',
      name: 'datashop',
      builder: (context, state) => const DataShopPage(),
    ),
    GoRoute(
      path: '/geoscientific-survey',
      name: 'geoscientific-survey',
      builder: (context, state) =>
          const GeoscientificMappingListPage(),
      routes: [
        GoRoute(
          path: 'mapping/new',
          name: 'geoscientific-mapping-new',
          builder: (context, state) =>
              const GeoscientificMappingCreatePage(),
        ),
      ],
    ),
  ],
);

/// Splash screen; redirects to /home after a short delay for testing.
class _SplashPage extends StatefulWidget {
  const _SplashPage();

  @override
  State<_SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Madini Mobile',
      usePortalHeader: false,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

