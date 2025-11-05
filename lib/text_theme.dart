import "package:flutter/material.dart";

const kFontFamily = "Manrope";
const kFontFamilyFallback = [".SF UI Text", ".SF UI Display", "Roboto", "Arial"];
const _kFontHeight = 1.4;

class AppTextTheme {
  const AppTextTheme._();

  static TextTheme getTextTheme({required bool isLight}) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 42,
        height: _kFontHeight,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: isLight ? Colors.black : Colors.white,
        // fontStyle: FontStyle.italic,
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        height: _kFontHeight,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: isLight ? Colors.black : Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 30,
        height: _kFontHeight,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: isLight ? Colors.black : Colors.white,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        height: _kFontHeight,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: isLight ? Colors.black : Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        height: _kFontHeight,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: isLight ? Colors.black : Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        height: _kFontHeight,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.25,
        color: isLight ? Colors.black : Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: _kFontHeight,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.25,
        color: isLight ? Colors.black : Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: _kFontHeight,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.25,
        color: isLight ? Colors.black : Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: _kFontHeight,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.25,
        color: isLight ? Colors.black : Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        height: _kFontHeight,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: isLight ? Colors.black : Colors.white,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        height: _kFontHeight,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: isLight ? Colors.black : Colors.white,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        height: _kFontHeight,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: isLight ? Colors.black : Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        height: _kFontHeight,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: isLight ? Colors.black : Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        height: _kFontHeight,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.6,
        color: isLight ? Colors.black : Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 11,
        height: _kFontHeight,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.6,
        color: isLight ? Colors.black : Colors.white,
      ),
    );
  }
}
