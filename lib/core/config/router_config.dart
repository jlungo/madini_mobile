import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../shared/widgets/app_scaffold.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/switchboard_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/datashop/presentation/pages/datashop_page.dart';
import '../../features/geoscientific_survey/presentation/pages/geoscientific_mapping_list_page.dart';
import '../../features/geoscientific_survey/presentation/pages/geoscientific_mapping_create_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Basic router configuration with auth guard.
GoRouter appRouter(AuthProvider authProvider) => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  refreshListenable: authProvider,
  redirect: (context, state) {
    final bool loggingIn = state.matchedLocation == '/login';
    final bool isLoggedIn = authProvider.isAuthenticated;

    // If not logged in and not on login page, redirect to login
    if (!isLoggedIn && !loggingIn && state.matchedLocation != '/') {
      return '/login';
    }

    // If logged in and on login page, redirect to home
    if (isLoggedIn && loggingIn) {
      return '/home';
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
    debugPrint('[Splash] _init started');
    // Wait a bit for the splash animation/feel
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('[Splash] 2 seconds delay passed');
    
    if (mounted) {
      // Initialize auth check
      final authProvider = context.read<AuthProvider>();
      debugPrint('[Splash] Initializing auth check...');
      await authProvider.checkAuthStatus();
      debugPrint('[Splash] Auth check completed: ${authProvider.isAuthenticated}');
      
      if (mounted) {
        if (authProvider.isAuthenticated) {
          debugPrint('[Splash] Redirecting to /home');
          context.go('/home');
        } else {
          debugPrint('[Splash] Redirecting to /login');
          context.go('/login');
        }
      }
    } else {
      debugPrint('[Splash] Widget not mounted after delay');
    }
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
