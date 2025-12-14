// ignore_for_file: avoid_print

import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wasm_bug_report/animated_blur.dart';
import 'package:wasm_bug_report/theme.dart';
import 'package:web/web.dart' hide Text;

const initialListLength = 700;

void logListData({
  required Uint8List list,
  required String debugName,
  required int expectedLength,
  required int expectedBufferLengthInBytes,
  required int expectedOffsetInBytes,
}) {
  print(
    "$debugName: List length: ${list.length} and offset: ${list.offsetInBytes} "
    "; Buffer length: ${list.buffer.lengthInBytes}; List type: ${list.runtimeType}",
  );

  if (list.length != expectedLength) {
    console.error("List length mismatch: ${list.length} != $expectedLength".toJS);
  }

  if (list.buffer.lengthInBytes != expectedBufferLengthInBytes) {
    console.error("Buffer length mismatch: ${list.buffer.lengthInBytes} != $expectedBufferLengthInBytes".toJS);
  }

  if (list.offsetInBytes != expectedOffsetInBytes) {
    console.error("Offset mismatch: ${list.offsetInBytes} != $expectedOffsetInBytes".toJS);
  }
}

void _testSublist(final Uint8List initialList) {
  print("--------------------------------");
  print("Test Sublist - ${initialList.runtimeType}");
  print("--------------------------------");

  // should have 690 items
  final sublist = initialList.sublist(
    /* start */ 10,
    /* end */ 700,
  );
  logListData(
    list: sublist,
    debugName: "sublist",
    expectedLength: 690,
    expectedBufferLengthInBytes: 690,
    expectedOffsetInBytes: 0,
  );

  // should have 690 items
  final view = Uint8List.view(
    initialList.buffer,
    /* offset */ 10,
    /* length */ 690,
  );
  logListData(
    list: view,
    debugName: "view",
    expectedLength: 690,
    expectedBufferLengthInBytes: 700,
    expectedOffsetInBytes: 10,
  );

  // should have 680 items
  logListData(
    list: sublist.sublist(
      /* start */ 10,
      /* end */ 690,
    ),
    debugName: "sublist of sublist",
    expectedLength: 680,
    expectedBufferLengthInBytes: 680,
    expectedOffsetInBytes: 0,
  );
  logListData(
    list: view.sublist(
      /* start */ 10,
      /* end */ 690,
    ),
    debugName: "sublist of view - end arg provided",
    expectedLength: 680,
    expectedBufferLengthInBytes: 680,
    expectedOffsetInBytes: 0,
  );

  logListData(
    list: view.sublist(
      /* start */ 10,
      /* end - not defined */
    ),
    debugName: "sublist of view - end arg not provided",
    expectedLength: 680,
    expectedBufferLengthInBytes: 680,
    expectedOffsetInBytes: 0,
  );
}

void main() {
  const isRunningWithWasm1 = bool.fromEnvironment("dart.tool.dart2wasm");
  const isRunningWithWasm2 = identical(double.nan, double.nan);

  print("App WASM Check 1: $isRunningWithWasm1");
  print("App WASM Check 2: $isRunningWithWasm2");

  {
    final initialList = Uint8List.fromList(List.generate(initialListLength, (index) => index));
    _testSublist(initialList);
  }
  {
    final jsList = JSUint8Array.withLength(initialListLength);

    for (var i = 0; i < initialListLength; i++) {
      jsList.setProperty(i.toJS, i.toJS);
    }

    _testSublist(jsList.toDart);
  }

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
              discreetModeEnabled: false,
              child: Text(
                '\$123',
                style: theme.textTheme.titleMedium,
              ),
            ),
            Text(
              '\$123',
              style: theme.textTheme.bodyLarge,
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
