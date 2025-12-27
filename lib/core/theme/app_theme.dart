import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors - Infused with Neobank Aesthetic
  static const Color primaryColor = Color(0xFF0D291E); // Deep Forest Green
  static const Color accentColor = Color(0xFFD4FF33);  // Neon Lime
  static const Color backgroundColor = Colors.white;
  static const Color scaffoldColor = Color(0xFFF9FBF9); // Very subtle green-tinted white
  static const Color cardColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF1F4F1); // Light mint for surfaces
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0D291E); // Using deep green for primary text too
  static const Color textSecondary = Color(0xFF75837D); // Muted green-grey
  static const Color textTertiary = Color(0xFFA1A7B0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldColor,
      cardColor: cardColor,
      
      // Font Family
      fontFamily: GoogleFonts.outfit().fontFamily,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.w700, letterSpacing: -1.0),
        displayMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        displaySmall: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        
        headlineLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 32, letterSpacing: -1.0),
        headlineMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 24, letterSpacing: -0.5),
        headlineSmall: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 20),
        
        titleLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 20, letterSpacing: -0.2),
        titleMedium: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        titleSmall: const TextStyle(color: textSecondary, fontWeight: FontWeight.w600, fontSize: 14),
        
        bodyLarge: const TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: const TextStyle(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: const TextStyle(color: textTertiary, fontSize: 12, fontWeight: FontWeight.w500),
        
        labelLarge: const TextStyle(color: primaryColor, fontWeight: FontWeight.w700),
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Outfit',
          letterSpacing: -0.5,
        ),
      ),
      
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: accentColor,
        secondary: accentColor,
        surface: surfaceColor,
      ),
      
      iconTheme: const IconThemeData(color: textPrimary),
      dividerColor: Colors.grey[200],
    );
  }
}
