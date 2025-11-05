// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wasm_bug_report/animated_blur.dart';

const kFontFamily = "Manrope";
const kFontFamilyFallback = [".SF UI Text", ".SF UI Display", "Roboto", "Arial"];

void main() {
  const isRunningWithWasm1 = bool.fromEnvironment("dart.tool.dart2wasm");
  const isRunningWithWasm2 = identical(double.nan, double.nan);

  print("App WASM Check 1: $isRunningWithWasm1");
  print("App WASM Check 2: $isRunningWithWasm2");

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool discreetModeEnabled = true;

  final theme = ThemeData(
    fontFamily: kFontFamily,
    fontFamilyFallback: kFontFamilyFallback,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text('Hello World!'),
              DiscreetWidget(
                discreetModeEnabled: discreetModeEnabled,
                child: Text('\$123'),
              ),
              Blurred(
                sigmaX: 10,
                sigmaY: 5,
                tileMode: TileMode.decal,
                child: Text('123'),
              ),
              Blurred(
                sigmaX: 10,
                sigmaY: 5,
                tileMode: TileMode.decal,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
              ),
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 5,
                  tileMode: TileMode.clamp,
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
              ),
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                  tileMode: TileMode.clamp,
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
              ),
              Text('123'),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    discreetModeEnabled = !discreetModeEnabled;
                  });
                },
                child: Text('Toggle Discreet Mode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
