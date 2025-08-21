// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/size.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData? theme = ThemeData(
      colorScheme: ColorScheme.light(
          primary: AppColors.brandColorDark,
          onPrimary: AppColors.brandColorWhite,
          secondary: AppColors.brandColorDark,
          onSecondary: AppColors.brandColorWhite,
          onSurface: AppColors.brandColorDark,
          surface: AppColors.neutralWhite),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(AppColors.brandColorDark),
              foregroundColor:
                  WidgetStateProperty.all<Color>(AppColors.brandColorWhite),
              textStyle: WidgetStateProperty.all<TextStyle>(
                  TextStyle(fontSize: 16, color: AppColors.brandColorWhite)))),
      textTheme: TextTheme(
          // Headline Styles
          headlineLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w600, // Slightly bolder for better emphasis
            color: AppColors
                .brandColorDark, // Maintain the dark color for strong headlines
          ),
          headlineMedium: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500, // Medium weight for a balanced look
            color: AppColors.brandColorDark, // Dark color for headlines
          ),

          // Body Text Styles
          bodyLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            color: AppColors
                .brandColorDark, // Lighter gray for body text, more readable
          ),
          bodyMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: AppColors
                .brandColorDark, // Consistent with bodyLarge for a uniform look
          ),
          bodySmall: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: AppColors
                .brandColorDark, // Slightly darker gray for small text, better legibility
          ),

          // Title Styles
          titleLarge: TextStyle(
            fontSize: 20.0,
            color: AppColors.brandColorDark,
            // Dark for emphasis
            fontWeight: FontWeight.w500, // Slightly bold for title distinction
          ),
          titleMedium: TextStyle(
            fontSize: 18.0,
            color: AppColors.brandColorDark, // Dark color for titles
            fontWeight: FontWeight.w500, // Bold enough to stand out
          ),
          titleSmall: TextStyle(
            fontSize: 14.0,
            color: AppColors.brandColorDark, // Consistent dark color for titles
            fontWeight: FontWeight.w500, // Light weight to maintain harmony
          ),
          labelLarge:
              TextStyle(fontSize: 20.0, color: AppColors.neutralGrayLight),
          labelMedium:
              TextStyle(fontSize: 14.0, color: AppColors.neutralGrayLight),
          labelSmall:
              TextStyle(fontSize: 14.0, color: AppColors.neutralGrayLight)));
  static ThemeData? vintageTheme = ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF3D5A80), // Deep muted blue from the stamp
        onPrimary: Color(0xFFFFFFFF), // White text/icons for contrast
        secondary:
            Color(0xFFE29578), // Soft faded red (inspired by flower buds)
        onSecondary: Color(0xFF2C2C2C), // Dark ink-like text color
        background: Color(0xFFFAF4EE), // Soft warm off-white (paper-like)
        onBackground: Color(0xFF3D3D3D), // Dark grey for contrast
        surface:
            Color(0xFFEEE3DA), // Light beige (vintage paper feel for cards)
        onSurface: Color(0xFF3D3D3D), // Text/icons on surfaces
        error: Color(0xFFBA2D2D), // Classic deep red for errors
        onError: Color(0xFFFFFFFF), // White text on error color
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(AppColors.brandColorDark),
              foregroundColor:
                  WidgetStateProperty.all<Color>(AppColors.brandColorWhite),
              textStyle: WidgetStateProperty.all<TextStyle>(
                  TextStyle(fontSize: 16, color: AppColors.brandColorWhite)))),
      textTheme: TextTheme(
          // Headline Styles
          headlineLarge: GoogleFonts.ebGaramond(
              fontSize: 32), // Maintain the dark color for strong headlines

          headlineMedium: GoogleFonts.ebGaramond(fontSize: 32),

          // Body Text Styles
          bodyLarge: GoogleFonts.ebGaramond(fontSize: 20),
          bodyMedium: GoogleFonts.ebGaramond(fontSize: 18),
          bodySmall: GoogleFonts.ebGaramond(fontSize: 14),

          // Title Styles
          titleLarge:
              GoogleFonts.ebGaramond(fontSize: 20, fontWeight: FontWeight.w500),
          titleMedium:
              GoogleFonts.ebGaramond(fontSize: 18, fontWeight: FontWeight.w500),
          titleSmall:
              GoogleFonts.ebGaramond(fontSize: 14, fontWeight: FontWeight.w500),
          labelLarge: GoogleFonts.ebGaramond(fontSize: 20),
          labelMedium: GoogleFonts.ebGaramond(fontSize: 14),
          labelSmall: GoogleFonts.ebGaramond(fontSize: 14)));

  static ElevatedButtonThemeData _buttonThemeLight = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFA5D8FF), // Pastel Blue
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
  );

  static ElevatedButtonThemeData _buttonThemeDark = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFD8BFD8), // Pastel Purple
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
  );

  // 🎭 Input Field Theme
  static InputDecorationTheme _inputThemeLight = InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF6F5F2),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    hintStyle: TextStyle(color: Color(0xFF888888)),
  );

  static InputDecorationTheme _inputThemeDark = InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    hintStyle: TextStyle(color: Color(0xFFBBBBBB)),
  );

  static Map<String, double> chatTextSize = {
    "Small": 18,
    "Medium": 20,
    "Large": 24
  };

  static double defineMsgBoxSize(BuildContext context) {
    double? size = AppTheme.chatTextSize[
        CurrentUserSetting.instance.userSetting.selectedMessageFont];

    if (size != null) {
      if (size == 18) {
        return SizeOf.intance.getWidth(context, 0.65);
      } else if (size == 20) {
        return SizeOf.intance.getWidth(context, 0.60);
      } else {
        return SizeOf.intance.getWidth(context, 0.50);
      }
    } else {
      return SizeOf.intance.getWidth(context, 0.60);
    }
  }
}
