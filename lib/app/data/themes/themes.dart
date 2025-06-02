import 'package:flutter/material.dart';
import 'package:storyapp_dicoding/app/data/themes/color_themes.dart';

ThemeData themeData = ThemeData(
  splashColor: Colors.transparent,
  scaffoldBackgroundColor: whiteColor.shade300,
  primaryColor: primaryColor,
  shadowColor: primaryColor.withAlpha((0.2 * 255).toInt()),
  cardTheme: CardThemeData(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    shadowColor: primaryColor.withAlpha((0.2 * 255).toInt()),
  ),
  colorScheme: ColorScheme.fromSwatch(
    accentColor: secondaryColor,
  ).copyWith(primary: primaryColor, secondary: secondaryColor),
  fontFamily: 'Nunito',
  iconTheme: IconThemeData(color: primaryColor),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w900, fontSize: 56),
    displayMedium: TextStyle(fontWeight: FontWeight.w900, fontSize: 42),
    displaySmall: TextStyle(fontWeight: FontWeight.w900, fontSize: 32),
    headlineLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
    headlineMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
    headlineSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
    titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
    titleMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
    titleSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    labelMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    labelSmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    bodyLarge: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
    bodyMedium: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
    bodySmall: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
  ).apply(displayColor: blackColor, bodyColor: blackColor, decorationColor: blackColor),
  appBarTheme: AppBarTheme(color: whiteColor.shade300),
);
