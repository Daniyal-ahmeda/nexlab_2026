import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color primaryBlue = Color(0xFF1E6DFB);
  static const Color primaryBlueDark = Color(0xFF0F56D3);
  static const Color primaryCyan = Color(0xFF06B6D4);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0B0F19);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF161F30);

  // Status colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color coralRed = Color(0xFFEF4444);
  static const Color purpleAmethyst = Color(0xFF8B5CF6);
  static const Color orangeSunset = Color(0xFFF97316);
  static const Color amberGold = Color(0xFFF59E0B);
  static const Color pinkRose = Color(0xFFEC4899);

  static const Color textMainLight = Color(0xFF0F172A);
  static const Color textMutedLight = Color(0xFF64748B);
  static const Color textMainDark = Color(0xFFF8FAFC);
  static const Color textMutedDark = Color(0xFF94A3B8);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: emeraldGreen,
        surface: backgroundLight,
        onPrimary: Colors.white,
        onSurface: textMainLight,
        error: coralRed,
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textMainLight),
        titleTextStyle: TextStyle(
          color: textMainLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Outfit',
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Outfit', fontSize: 32, fontWeight: FontWeight.bold, color: textMainLight),
        headlineMedium: TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.bold, color: textMainLight),
        titleLarge: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w700, color: textMainLight),
        titleMedium: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600, color: textMainLight),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 15, color: textMainLight),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 13.5, color: textMutedLight),
        labelLarge: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.bold, color: primaryBlue),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: emeraldGreen,
        surface: backgroundDark,
        onPrimary: Colors.white,
        onSurface: textMainDark,
        error: coralRed,
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textMainDark),
        titleTextStyle: TextStyle(
          color: textMainDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Outfit',
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Outfit', fontSize: 32, fontWeight: FontWeight.bold, color: textMainDark),
        headlineMedium: TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.bold, color: textMainDark),
        titleLarge: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w700, color: textMainDark),
        titleMedium: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600, color: textMainDark),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 15, color: textMainDark),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 13.5, color: textMutedDark),
        labelLarge: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.bold, color: primaryBlue),
      ),
    );
  }

  // Gradients for cards and backgrounds
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF1E6DFB), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient profileScoreGradient = LinearGradient(
    colors: [Color(0xFF1E6DFB), Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Modern Box Shadow helper
  static List<BoxShadow> cardShadow(bool isDark) {
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
    }
    return [
      BoxShadow(
        color: const Color(0xFF64748B).withValues(alpha: 0.08),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
