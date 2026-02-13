import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/config/router_config.dart';
import '../core/theme/app_theme.dart';
import '../state/theme_provider.dart';

class MadiniApp extends StatelessWidget {
  const MadiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'Madini Mobile',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeProvider.mode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}

