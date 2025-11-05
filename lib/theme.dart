import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasm_bug_report/text_theme.dart';

final kAppLightTheme = ThemeData(
  fontFamily: kFontFamily,
  fontFamilyFallback: kFontFamilyFallback,
  textTheme: AppTextTheme.getTextTheme(isLight: true),
);
