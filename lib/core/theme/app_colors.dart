import 'package:flutter/material.dart';

/// AppColors class defines the core palette for UlakChat application.
class AppColors {
  AppColors._();

  // Primary Colors (Teal / Cyan theme derived from logo branding)
  static const Color primary = Color(0xFF00A896);
  static const Color primaryLight = Color(0xFF02C39A);
  static const Color primaryDark = Color(0xFF05668D);

  // Accent / Secondary Colors (Warm Orange/Amber highlights)
  static const Color accent = Color(0xFFF77F00);
  static const Color accentLight = Color(0xFFFCBF49);

  // Neutral Light Theme Colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFF1F5F9);

  // Neutral Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF1E293B);

  // Status & Utility Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color onlineStatus = Color(0xFF22C55E);
  static const Color unreadBadge = Color(0xFFF77F00);
}
