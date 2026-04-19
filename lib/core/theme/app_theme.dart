import 'package:flutter/material.dart';
import 'app_colors.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.textIcons,
    secondary: AppColors.accent,
    onSecondary: AppColors.primaryText,
    error: Colors.red,
    onError: AppColors.textIcons,
    surface: Colors.white,
    onSurface: AppColors.primaryText,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textIcons,
    elevation: 4,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
    foregroundColor: AppColors.primaryText,
  ),
  dividerColor: AppColors.divider,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.primaryText),
    bodyMedium: TextStyle(color: AppColors.primaryText),
    bodySmall: TextStyle(color: AppColors.secondaryText),
    titleMedium: TextStyle(color: AppColors.primaryText),
    titleSmall: TextStyle(color: AppColors.secondaryText),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textIcons,
    ),
  ),
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 2,
  ),
);
