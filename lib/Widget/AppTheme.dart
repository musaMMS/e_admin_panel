import 'package:flutter/material.dart';

import 'AppColors.dart';


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.primaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.iconColor,
        elevation: 4,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: AppColors.accentColor,
        unselectedItemColor: AppColors.unselectedColor,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.textColor, fontSize: 18),
        bodyMedium: TextStyle(color: AppColors.textColor),
        titleLarge: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
      ),
      iconTheme: IconThemeData(color: AppColors.iconColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: AppColors.textColor,
        ),
      ),
    );
  }
}
