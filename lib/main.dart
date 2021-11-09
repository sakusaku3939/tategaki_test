import 'package:flutter/material.dart';

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
                "吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕えて煮て食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。"),
          );
        },
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  _MyPainter(this.text);

  final String text;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    const fontSize = 24;

    final rowCount = text.length * fontSize ~/ size.height;
    final columnCount = size.height ~/ fontSize;
    final runes = text.runes;

    for (int x = 0; x < rowCount; x++) {
      for (int y = 0; y < columnCount; y++) {
        TextSpan span = TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
          text: String.fromCharCode(runes.elementAt(x * columnCount + y)),
        );
        TextPainter tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas,
            Offset((x * fontSize).toDouble(), (y * fontSize).toDouble()));
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
