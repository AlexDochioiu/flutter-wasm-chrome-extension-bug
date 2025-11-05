import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wasm_bug_report/text_theme.dart';

final kAppLightTheme = ThemeData(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      // Set the predictive back transitions for Android.
      // TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),

      // [FadeForwardsPageTransitionsBuilder] from flutter framework is broken in Flutter 3.29.0
      // (screen going black when navigating back from a top level route such as send tx or recovery phrase page)
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  // ignore: deprecated_member_use
  progressIndicatorTheme: const ProgressIndicatorThemeData(year2023: true),
  fontFamily: kFontFamily,
  fontFamilyFallback: kFontFamilyFallback,
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  visualDensity: VisualDensity.compact,
  splashFactory: InkRipple.splashFactory,
  textTheme: AppTextTheme.getTextTheme(isLight: true),
  useMaterial3: true,
  applyElevationOverlayColor: false,
  colorScheme: ColorScheme.light(),
  shadowColor: Colors.black,
  iconTheme: const IconThemeData(color: Colors.black),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF),
    actionsIconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontFamily: kFontFamily,
      fontFamilyFallback: kFontFamilyFallback,
    ),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  cardTheme: CardThemeData(
    margin: EdgeInsets.zero,
    color: const Color(0xFFFAFAFa),
    surfaceTintColor: const Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.black,
  ),
  typography: Typography.material2021(platform: TargetPlatform.android),
);
