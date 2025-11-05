// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:wasm_bug_report/animated_blur.dart';
import 'package:wasm_bug_report/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: kAppLightTheme,
      home: MainAppWidget(
        discreetModeEnabled: discreetModeEnabled,
        onDiscreetModeToggle: () {
          setState(() {
            discreetModeEnabled = !discreetModeEnabled;
          });
        },
      ),
    );
  }
}

class MainAppWidget extends StatelessWidget {
  final bool discreetModeEnabled;
  final void Function() onDiscreetModeToggle;
  const MainAppWidget({
    super.key,
    required this.discreetModeEnabled,
    required this.onDiscreetModeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 40,
          children: [
            Text(
              'Hello World!',
              style: theme.textTheme.displayLarge,
            ),
            DiscreetWidget(
              discreetModeEnabled: discreetModeEnabled,
              child: Text(
                '\$123',
                style: theme.textTheme.titleMedium,
              ),
            ),
            Blurred(
              sigmaX: 10,
              sigmaY: 5,
              tileMode: TileMode.decal,
              child: Text(
                '123',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Flexible(
              child: Text(
                '123',
                style: theme.textTheme.titleMedium,
              ),
            ),
            ElevatedButton(
              onPressed: onDiscreetModeToggle,
              child: Text('Toggle Discreet Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
