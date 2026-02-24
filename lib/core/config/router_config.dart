import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/security/permissions.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/permission_page_guard.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/switchboard_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/datashop/presentation/pages/datashop_page.dart';
import '../../features/geoscientific_survey/presentation/pages/geoscientific_mapping_create_page.dart';
import '../../features/geoscientific_survey/presentation/pages/geoscientific_mapping_list_page.dart';
import '../../features/geoscientific_survey/presentation/pages/geosurvey_placeholder_page.dart';
import '../../features/geoscientific_survey/presentation/pages/geosurvey_shell_page.dart';
import '../../features/geoscientific_survey/presentation/pages/map_viewer_placeholder_page.dart';
import '../../features/geoscientific_survey/presentation/pages/mapping_activity_detail_page.dart';
import '../../features/geoscientific_survey/presentation/pages/geoscientific_mapping_edit_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Basic router configuration with auth guard.
GoRouter appRouter(AuthProvider authProvider) => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  refreshListenable: authProvider,
  redirect: (context, state) {
    final bool loggingIn = state.matchedLocation == '/login';
    final bool isLoggedIn = authProvider.isAuthenticated;
    final bool sessionExpired =
        authProvider.status == AuthStatus.sessionExpired;

    if (sessionExpired || (!isLoggedIn && !loggingIn && state.matchedLocation != '/')) {
      return '/login';
    }
    if (isLoggedIn && loggingIn) {
      return '/home';
    }
    // Redirect bare geosurvey root to the mapping activity list.
    if (state.matchedLocation == '/geoscientific-survey') {
      return '/geoscientific-survey/mapping-activity';
    }
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const _SplashPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const SwitchboardPage(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
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

    // ── Geosurvey ShellRoute ─────────────────────────────────────────────────
    // All paths are absolute. The shell provides the drawer nav; each child
    // renders as the shell body. Auth enforced by the top-level redirect above.
    ShellRoute(
      builder: (context, state, child) => GeosurveyShellPage(child: child),
      routes: [
        GoRoute(
          path: '/geoscientific-survey/mapping-activity',
          name: 'geoscientific-mapping-activity',
          builder: (context, state) => PermissionPageGuard(
            requiredAnyPermissions: [GeosurveyPermissions.mappingActivityList],
            child: const GeoscientificMappingListPage(useScaffold: false),
          ),
        ),
        GoRoute(
          path: '/geoscientific-survey/deposits',
          name: 'geosurvey-deposits',
          builder: (context, state) => PermissionPageGuard(
            requiredAnyPermissions: [GeosurveyPermissions.depositList],
            child: const GeosurveyPlaceholderPage(title: 'Deposits'),
          ),
        ),
        GoRoute(
          path: '/geoscientific-survey/mines',
          name: 'geosurvey-mines',
          builder: (context, state) => PermissionPageGuard(
            requiredAnyPermissions: [GeosurveyPermissions.mineList],
            child: const GeosurveyPlaceholderPage(title: 'Mines'),
          ),
        ),
        GoRoute(
          path: '/geoscientific-survey/drill-holes',
          name: 'geosurvey-drill-holes',
          builder: (context, state) => PermissionPageGuard(
            requiredAnyPermissions: [GeosurveyPermissions.drillHoleList],
            child: const GeosurveyPlaceholderPage(title: 'Drill Holes'),
          ),
        ),
        GoRoute(
          path: '/geoscientific-survey/geochemistry',
          name: 'geosurvey-geochemistry',
          builder: (context, state) => PermissionPageGuard(
            requiredAnyPermissions: [GeosurveyPermissions.geochemistryList],
            child: const GeosurveyPlaceholderPage(title: 'Geochemistry'),
          ),
        ),
        GoRoute(
          path: '/geoscientific-survey/map-viewer',
          name: 'geosurvey-map-viewer',
          builder: (context, state) => PermissionPageGuard(
            requiredAnyPermissions: [GeosurveyPermissions.mapViewerView],
            child: const MapViewerPlaceholderPage(),
          ),
        ),
        GoRoute(
          path: '/geoscientific-survey/data',
          name: 'geosurvey-data',
          builder: (context, state) => PermissionPageGuard(
            requiredAnyPermissions: [GeosurveyPermissions.geochemistryList],
            child: const GeosurveyPlaceholderPage(title: 'Data'),
          ),
        ),
        GoRoute(
          path: '/geoscientific-survey/reports',
          name: 'geosurvey-reports',
          builder: (context, state) => PermissionPageGuard(
            requiredAnyPermissions: [GeosurveyPermissions.reportList],
            child: const GeosurveyPlaceholderPage(title: 'Reports'),
          ),
        ),
        GoRoute(
          path: '/geoscientific-survey/locations',
          name: 'geosurvey-locations',
          builder: (context, state) => PermissionPageGuard(
            requiredAnyPermissions: [GeosurveyPermissions.locationList],
            child: const GeosurveyPlaceholderPage(title: 'Locations'),
          ),
        ),
      ],
    ),

    // ── Geosurvey full-screen routes (no shell) ───────────────────────────────
    // Top-level routes use the root navigator directly; no parentNavigatorKey needed.
    GoRoute(
      path: '/geoscientific-survey/mapping/new',
      name: 'geoscientific-mapping-new',
      builder: (context, state) => PermissionPageGuard(
        requiredAnyPermissions: [GeosurveyPermissions.mappingActivityCreate],
        child: const GeoscientificMappingCreatePage(),
      ),
    ),
    GoRoute(
      path: '/geoscientific-survey/mapping-activity/:id',
      name: 'geoscientific-mapping-detail',
      builder: (context, state) => PermissionPageGuard(
        requiredAnyPermissions: GeosurveyPermissions.mappingActivityView,
        child: MappingActivityDetailPage(
          activityId: state.pathParameters['id'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/geoscientific-survey/mapping/:id/edit',
      name: 'geoscientific-mapping-edit',
      builder: (context, state) => PermissionPageGuard(
        requiredAnyPermissions: GeosurveyPermissions.mappingActivityUpdate,
        child: GeoscientificMappingEditPage(
          activityId: state.pathParameters['id'] ?? '',
        ),
      ),
    ),
  ],
);

/// Splash screen; checks auth status then redirects.
class _SplashPage extends StatefulWidget {
  const _SplashPage();

  @override
  State<_SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkAuthStatus();
    if (!mounted) return;
    if (authProvider.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Madini Mobile',
      usePortalHeader: false,
      showBackButton: false,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
