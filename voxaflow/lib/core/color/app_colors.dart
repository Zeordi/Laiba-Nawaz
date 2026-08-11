import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color gradientButton = Color(0xFF7E97A1); // Lagoon
  static const Color primary = Color(0xFF1F4A4D); // Seaweed
  static const Color primaryLight = Color(0xFF7E97A1); // Lagoon
  static const Color primaryShadow = Color(
    0xFF16383A,
  ); // Dark Seaweed for shadow

  // Accent Colors
  static const Color accent = Color(0xFF7E97A1); // Lagoon
  static const Color accent15 = Color(0x267E97A1); // @15% opacity
  static const Color accent25 = Color(0x407E97A1); // @25% opacity
  static const Color accentDark = Color(0xFF1F4A4D); // Seaweed

  // Status Colors
  // Success (Green)
  static const Color success = Color(0xFF7E97A1); // Lagoon
  static const Color success15 = Color(0x267E97A1); // @15% opacity
  static const Color successDark = Color(0xFF1F4A4D); // Seaweed

  // Error/Alert (Red - same as accent)
  static const Color error = Color(0xFF1F4A4D); // Seaweed
  static const Color error15 = Color(0x261F4A4D); // @15% opacity
  static const Color errorDark = Color(0xFF16383A);

  // Warning (using accent color for now, can be customized)
  static const Color warning = Color(0xFF7E97A1); // Lagoon
  static const Color warningLight = Color(0xFFDCE6E5); // Silver Lake

  // Info (using primary for now)
  static const Color info = Color(0xFF1F4A4D); // Seaweed
  static const Color infoLight = Color(0xFF7E97A1); // Lagoon

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Text Colors (Grey)
  static const Color textDefault = Color(
    0xFF464A52,
  ); // Default for normal texts
  static const Color textHeadline = Color(
    0xFF181D27,
  ); // Dark grey for headline texts
  static const Color textPlaceholder = Color(
    0xCC464A52,
  ); // @80% opacity for placeholders
  static const Color textLight = Color(0xFFD0D2D5); // Light grey
  static const Color textLine = Color(0xFFE2E2E2); // Grey for lines

  // Background Colors
  static const Color background = Color(0xFFDCE6E5); // Silver Lake
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  // Border & Divider Colors
  static const Color border = Color(0xFFC9D5D4); // Silver Lake dark
  static const Color divider = Color(0xFFC9D5D4); // Silver Lake dark

  // Shadow Colors
  static const Color shadow = Color(
    0x1A1F4A4D,
  ); // Using primary color for shadow
  static const Color shadowDark = Color(0x3D1F4A4D);

  // Legacy support (for backward compatibility)
  static const Color textPrimary = textHeadline;
  static const Color textSecondary = textDefault;
  static const Color textDisabled = textPlaceholder;
  static const Color grey = textDefault;
  static const Color greyLight = textLine;
  static const Color greyDark = textHeadline;
  static const Color backgroundLight = background;
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = surface;
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color borderLight = border;
  static const Color borderDark = Color(0xFF424242);
  static const Color dividerLight = divider;
  static const Color dividerDark = Color(0xFF424242);
  static const Color shadowLight = shadow;

  // Home ad card colors
  static const Color adCardBg = Color(0xFF7E97A1); // Lagoon
  static const Color lighAdCardBg = Color(0xFFDCE6E5); // Silver Lake
  static const Color catagoryButton = Color(0xECDCE6E5);
  static const Color subscriptionIcon = Color(0xFF1F4A4D); // Seaweed
  static const Color subscriptionCard = Color(0xECDCE6E5);
  // Private constructor to prevent instantiation
  // booking
  static const Color bookingPending = Color(0xFF7E97A1); // Lagoon
  static const Color bookingPendingText = Color(0xFF1F4A4D); // Seaweed
  static const Color bookingCancelled = Color(0xFF1F4A4D); // Seaweed
  AppColors._();
}