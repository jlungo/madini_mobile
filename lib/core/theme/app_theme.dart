import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Derived from web `globals.css` tokens
  // --primary: hsl(40, 67%, 31%);
  static const Color primary = Color(0xFF8B4513);
  static const Color primaryForegroundLight = Color(0xFFFAFAFA);

  // Light theme tokens (oklch approximations)
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color foregroundLight = Color(0xFF111827);
  static const Color secondaryLight = Color(0xFFF3F4F6);
  static const Color secondaryForegroundLight = Color(0xFF111827);

  // Dark theme tokens
  static const Color backgroundDark = Color(0xFF020617);
  static const Color foregroundDark = Color(0xFFF9FAFB);
  static const Color secondaryDark = Color(0xFF1F2937);
  static const Color secondaryForegroundDark = Color(0xFFF9FAFB);

  // Destructive maps to accentRed in mobile for now.
  static const Color accentRed = Color(0xFFee4742);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondaryLight,
      error: accentRed,
      brightness: Brightness.light,
    ).copyWith(
      surface: backgroundLight,
      onSurface: foregroundLight,
      onPrimary: primaryForegroundLight,
      onSecondary: secondaryForegroundLight,
    );

    final base = ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: colorScheme,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );

    final jakarta = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);
    final reduced = jakarta.copyWith(
      headlineLarge: jakarta.headlineLarge?.copyWith(
        fontSize: (jakarta.headlineLarge?.fontSize ?? 32) - 2,
      ),
      headlineMedium: jakarta.headlineMedium?.copyWith(
        fontSize: (jakarta.headlineMedium?.fontSize ?? 28) - 2,
      ),
      headlineSmall: jakarta.headlineSmall?.copyWith(
        fontSize: (jakarta.headlineSmall?.fontSize ?? 24) - 1,
      ),
      titleLarge: jakarta.titleLarge?.copyWith(
        fontSize: (jakarta.titleLarge?.fontSize ?? 22) - 1,
      ),
      titleMedium: jakarta.titleMedium?.copyWith(
        fontSize: (jakarta.titleMedium?.fontSize ?? 16) - 1,
      ),
      titleSmall: jakarta.titleSmall?.copyWith(
        fontSize: (jakarta.titleSmall?.fontSize ?? 14) - 1,
      ),
      bodyLarge: jakarta.bodyLarge?.copyWith(
        fontSize: (jakarta.bodyLarge?.fontSize ?? 16) - 1,
      ),
      bodyMedium: jakarta.bodyMedium?.copyWith(
        fontSize: (jakarta.bodyMedium?.fontSize ?? 14) - 1,
      ),
      bodySmall: jakarta.bodySmall?.copyWith(
        fontSize: (jakarta.bodySmall?.fontSize ?? 12) - 1,
      ),
      labelLarge: jakarta.labelLarge?.copyWith(
        fontSize: (jakarta.labelLarge?.fontSize ?? 14) - 1,
      ),
      labelMedium: jakarta.labelMedium?.copyWith(
        fontSize: (jakarta.labelMedium?.fontSize ?? 12) - 1,
      ),
      labelSmall: jakarta.labelSmall?.copyWith(
        fontSize: (jakarta.labelSmall?.fontSize ?? 11) - 1,
      ),
    );

    return base.copyWith(
      textTheme: reduced,
      primaryTextTheme: reduced,
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondaryDark,
      error: accentRed,
      brightness: Brightness.dark,
    ).copyWith(
      surface: backgroundDark,
      onSurface: foregroundDark,
      onPrimary: primaryForegroundLight,
      onSecondary: secondaryForegroundDark,
    );

    final base = ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: colorScheme,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );

    final jakarta = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);
    return base.copyWith(
      textTheme: jakarta,
      primaryTextTheme: jakarta,
    );
  }
}

