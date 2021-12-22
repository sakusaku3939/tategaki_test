import 'package:flutter/material.dart';
import 'package:untitled/vertical_rotated.dart';

class Tategaki extends StatelessWidget {
  Tategaki(
    this.text, {
    this.style,
    this.space = 12,
  });

  final String text;
  final TextStyle? style;
  final double space;

  @override
  Widget build(BuildContext context) {
    final mergeStyle = DefaultTextStyle.of(context).style.merge(style);
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight - 4),
          painter: _TategakiPainter(text, mergeStyle, space),
        );
      },
    );
  }
}

class _TategakiPainter extends CustomPainter {
  _TategakiPainter(this.text, this.style, this.space);

  final String text;
  final TextStyle style;
  final double space;

  int charIndex = 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final squareCountList = calcSquareCount(size);

    for (int x = 0; x < squareCountList.length; x++) {
      drawTextLine(canvas, size, x, squareCountList[x]);
    }

    canvas.restore();
  }

  List<int> calcSquareCount(Size size) {
    final columnSquareCount = size.height ~/ style.fontSize!;
    int i = 0;
    List<int> countList = [];

    for (int rune in text.runes) {
      final isLast = i == columnSquareCount - 1;
      final isLF = rune == '\n'.runes.first;

      if (isLF && i != 0) {
        countList.add(i);
        i = 0;
      } else if (isLast) {
        countList.add(i + 1);
        i = 0;
      } else {
        i++;
      }
    }
    countList.add(i);

    return countList;
  }

  void drawTextLine(Canvas canvas, Size size, int x, int columnCount) {
    final runes = text.replaceAll('\n', '').runes;
    final fontSize = style.fontSize!;
    final charWidth = fontSize + space;

    for (int y = 0; y < columnCount; y++) {
      if (runes.length <= charIndex) return;

      String char = String.fromCharCode(runes.elementAt(charIndex));
      if (VerticalRotated.map[char] != null) {
        char = VerticalRotated.map[char] ?? "";
      }

      TextSpan span = TextSpan(
        style: style,
        text: char,
      );
      TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );

      tp.layout();
      tp.paint(
        canvas,
        Offset(
          (size.width - (x + 1) * charWidth).toDouble(),
          (y * fontSize).toDouble(),
        ),
      );
      charIndex++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
