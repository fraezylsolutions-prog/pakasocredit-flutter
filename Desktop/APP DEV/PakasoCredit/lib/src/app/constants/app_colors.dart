import 'package:flutter/material.dart';

class AppColors {
  // ── Pakaso Credit Brand Colors ──────────────────────────────────────────

  // Primary — Navy Blue (from logo)
  static const Color primary = Color(0xFF0D2150);
  static const Color primaryLight = Color(0xFF1A3A7A);
  static const Color primaryDark = Color(0xFF071535);

  // Accent — Orange (from logo)
  static const Color accent = Color(0xFFF47920);
  static const Color accentLight = Color(0xFFF9A15A);
  static const Color accentDark = Color(0xFFD4620A);

  // Background Colors
  static const Color background = Color(0xFFF0F3FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFEEF0F8);

  // Text Colors
  static const Color textPrimary = Color(0xFF0D2150);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textTertiary = Color(0xFF9AA5B4);
  static const Color textLight = Color(0xFFCBD5E0);

  // ── Dark Theme Colors ───────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0A0F1E);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkPrimary = Color(0xFF4A7FD4);
  static const Color darkSecondary = Color(0xFF1A2340);
  static const Color darkCardBorder = Color(0xFF2D3748);
  static const Color darkCardBackground = Color(0xFF1E2A45);
  static const Color darkTextPrimary = Color(0xFFF7FAFC);
  static const Color darkTextSecondary = Color(0xFFE2E8F0);
  static const Color darkTextTertiary = Color(0xFF718096);

  // ── Status Colors ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ── Utility Colors ──────────────────────────────────────────────────────
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF9AA5B4);
  static const Color transparent = Colors.transparent;
  static const Color divider = Color(0xFFE2E8F0);
  static const Color shadow = Color(0x1A0D2150);

  // ── Gradient Presets ────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D2150), Color(0xFF1A3A7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF47920), Color(0xFFF9A15A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0D2150), Color(0xFF1E3A8A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
