import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Simple ChangeNotifier that toggles between light and dark themes.
class ThemeProvider extends ChangeNotifier {
  /// Default dark to match webapp/GST Field App (left design).
  ThemeMode _mode = ThemeMode.dark;

  ThemeMode get mode => _mode;

  ThemeData get light => AppTheme.light();

  ThemeData get dark => AppTheme.dark();

  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

