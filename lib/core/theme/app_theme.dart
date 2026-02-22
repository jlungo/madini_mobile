import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// For card content: dark text on light cards in dark theme.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color onCard;
  final Color onCardMuted;

  const AppThemeExtension({
    required this.onCard,
    required this.onCardMuted,
  });

  @override
  AppThemeExtension copyWith({Color? onCard, Color? onCardMuted}) {
    return AppThemeExtension(
      onCard: onCard ?? this.onCard,
      onCardMuted: onCardMuted ?? this.onCardMuted,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      onCard: Color.lerp(onCard, other.onCard, t)!,
      onCardMuted: Color.lerp(onCardMuted, other.onCardMuted, t)!,
    );
  }
}

/// Matches madini_webapp globals.css (light + dark).
class AppTheme {
  // Webapp :root / .dark --primary: hsl(40, 67%, 31%); --primary-foreground: hsl(0, 0%, 98%);
  static const Color primary = Color(0xFF7A5C1F);
  static const Color primaryForeground = Color(0xFFFAFAFA);

  // Light (:root) – background/card white, foreground dark
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color foregroundLight = Color(0xFF252525);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color secondaryLight = Color(0xFFF7F7F7);
  static const Color secondaryForegroundLight = Color(0xFF343434);

  // Dark (.dark) – charcoal background, light cards (GST Field App / left design)
  static const Color backgroundDark = Color(0xFF2B2B2B);
  static const Color foregroundDark = Color(0xFFFBFBFB);
  static const Color cardDark = Color(0xFFF0F0F0);
  static const Color cardForegroundDark = Color(0xFF252525);
  static const Color secondaryDark = Color(0xFF454545);
  static const Color secondaryForegroundDark = Color(0xFFFBFBFB);

  static const Color accentRed = Color(0xFFE64A4A);

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
      onPrimary: primaryForeground,
      onSecondary: secondaryForegroundLight,
      surfaceContainerLowest: cardLight,
    );

    final base = ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundLight,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardLight,
        shape: const RoundedRectangleBorder(
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
      extensions: [
        const AppThemeExtension(
          onCard: foregroundLight,
          onCardMuted: Color(0xFF55606A),
        ),
      ],
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
      onPrimary: primaryForeground,
      onSecondary: secondaryForegroundDark,
      surfaceContainerLowest: cardDark,
    );

    final base = ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundDark,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );

    final jakarta = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);
    return base.copyWith(
      textTheme: jakarta,
      primaryTextTheme: jakarta,
      extensions: [
        const AppThemeExtension(
          onCard: cardForegroundDark,
          onCardMuted: Color(0xFF505050),
        ),
      ],
    );
  }
}

