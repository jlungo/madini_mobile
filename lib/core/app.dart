import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/theme/app_theme.dart';
import '../providers.dart';
import '../state/theme_provider.dart';

class MadiniApp extends StatefulWidget {
  const MadiniApp({super.key});

  @override
  State<MadiniApp> createState() => _MadiniAppState();
}

class _MadiniAppState extends State<MadiniApp> {
  late final List<SingleChildWidget> _providers;

  @override
  void initState() {
    super.initState();
    _providers = getProviders();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers,
      child: Builder(
        builder: (context) {
          final themeProvider = context.watch<ThemeProvider>();
          final router = context.read<GoRouter>();

          return MaterialApp.router(
            title: 'Madini Mobile',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeProvider.mode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
