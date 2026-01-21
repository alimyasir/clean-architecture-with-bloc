import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class AppTheme {
  // Common Text Theme (base styles)
  static const TextTheme _baseTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 96.0, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: TextStyle(fontSize: 60.0, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w400),
    headlineMedium: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light(useMaterial3: true);
    const colorScheme = ColorScheme.light(
      primary: Color(0xFF1A73E8),
      onPrimary: Colors.white,
      secondary: Color(0xFF00897B),
      onSecondary: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      background: Color(0xFFF5F5F5),
      onBackground: Color(0xFF212121),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF212121),
    );
    return baseTheme.copyWith(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: GoogleFonts.robotoTextTheme(_baseTextTheme).apply(
        bodyColor: colorScheme.onBackground,
        displayColor: colorScheme.onBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4.0,
        titleTextStyle: GoogleFonts.robotoTextTheme(_baseTextTheme).titleLarge?.copyWith(color: colorScheme.onPrimary),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        color: colorScheme.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Or use colorScheme.outline
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        hintStyle: GoogleFonts.robotoTextTheme(_baseTextTheme).bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.robotoTextTheme(_baseTextTheme).bodyMedium?.copyWith(color: colorScheme.onSurface),
        inputDecorationTheme: InputDecorationTheme(
           filled: true,
           fillColor: colorScheme.surface,
           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide.none,
           ),
        )
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFF8AB4F8),
      onPrimary: Color(0xFF0D3C73),
      secondary: Color(0xFF4DB6AC),
      onSecondary: Color(0xFF003D37),
      error: Color(0xFFF48FB1),
      onError: Color(0xFF5C001F),
      background: Color(0xFF121212),
      onBackground: Color(0xFFE0E0E0),
      surface: Color(0xFF1E1E1E),
      onSurface: Color(0xFFE0E0E0),
    );
    return baseTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      textTheme: GoogleFonts.robotoTextTheme(_baseTextTheme).apply(
        bodyColor: colorScheme.onBackground,
        displayColor: colorScheme.onBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface, // Or colorScheme.primary for a colored bar
        foregroundColor: colorScheme.onSurface, // Or colorScheme.onPrimary
        elevation: 4.0,
        titleTextStyle: GoogleFonts.robotoTextTheme(_baseTextTheme).titleLarge?.copyWith(color: colorScheme.onSurface),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        color: colorScheme.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Or use colorScheme.outline
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
        ),
        hintStyle: GoogleFonts.robotoTextTheme(_baseTextTheme).bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.robotoTextTheme(_baseTextTheme).bodyMedium?.copyWith(color: colorScheme.onSurface),
         inputDecorationTheme: InputDecorationTheme(
           filled: true,
           fillColor: colorScheme.surface,
           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide.none,
           ),
        )
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
