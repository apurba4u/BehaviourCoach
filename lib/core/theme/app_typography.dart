import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// DisciplineOS Typography System
/// Hanken Grotesk (headlines), Inter (body), JetBrains Mono (data)
class AppTypography {
  AppTypography._();

  // Display
  static TextStyle displayLg = GoogleFonts.hankenGrotesk(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 56 / 48,
    letterSpacing: -0.02,
  );

  // Headlines
  static TextStyle headlineLg = GoogleFonts.hankenGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 40 / 32,
    letterSpacing: -0.01,
  );

  static TextStyle headlineLgMobile = GoogleFonts.hankenGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 36 / 28,
  );

  // Body
  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  // Label/Mono
  static TextStyle labelMono = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 16 / 13,
    letterSpacing: 0.05,
  );

  // Font families
  static const String fontDisplay = 'Hanken Grotesk';
  static const String fontBody = 'Inter';
  static const String fontMono = 'JetBrains Mono';
}
