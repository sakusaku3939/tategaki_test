import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled/vertical_rotated.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight - 32),
            painter: _MyPainter(
                text:
                    "「吾輩は猫である。名前-−はまだ無い。」どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕えて煮て食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。"),
          );
        },
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  _MyPainter({required this.text, this.fontSize = 24, this.space = 12});

  final String text;
  final double fontSize;
  final int space;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final columnCount = size.height ~/ fontSize;
    final rowCount = (text.length / columnCount).ceil();

    print("$rowCount $columnCount ${(text.length * fontSize) % size.height}");

    // print(String.fromCharCode(0x3063));

    for (int x = 0; x < rowCount; x++) {
      drawTextLine(canvas, size, x, columnCount);
    }

    canvas.restore();
  }

  void drawTextLine(Canvas canvas, Size size, int x, int columnCount) {
    final runes = text.runes;
    final charWidth = fontSize + space;

    for (int y = 0; y < columnCount; y++) {
      final charIndex = x * columnCount + y;
      if (runes.length <= charIndex) return;

      String char = String.fromCharCode(runes.elementAt(charIndex));
      if (VerticalRotated.map[char] != null) {
        char = VerticalRotated.map[char] ?? "";
      }

      // print("0x" + runes.elementAt(x * columnCount + y).toRadixString(16));
      TextSpan span = TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
        ),
        text: char,
      );
      TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );

      tp.layout();

      // if (VerticalRotated.r90degree.contains(char)) {
      //   canvas.save();
      //   canvas.translate(
      //     (size.width - charWidth - x * charWidth).toDouble(),
      //     (y * fontSize).toDouble(),
      //   );
      //   canvas.rotate(pi / 2);
      //   tp.paint(
      //     canvas,
      //     Offset(fontSize / 2, -(fontSize + space / 2)),
      //     // const Offset(0, 0),
      //     // Offset(
      //     //   (size.width - charWidth - x * charWidth).toDouble(),
      //     //   (y * fontSize).toDouble(),
      //     // ),
      //   );
      //   canvas.restore();
      // } else {

      tp.paint(
        canvas,
        Offset(
          (size.width - charWidth - x * charWidth).toDouble(),
          (y * fontSize).toDouble(),
        ),
      );
      // }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
