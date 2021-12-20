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
          size: Size(
            constraints.maxWidth,
            constraints.maxHeight - 4,
          ),
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

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final columnCount = size.height ~/ style.fontSize!;
    final rowCount = (text.length / columnCount).ceil();

    for (int x = 0; x < rowCount; x++) {
      drawTextLine(canvas, size, x, columnCount);
    }

    canvas.restore();
  }

  void drawTextLine(Canvas canvas, Size size, int x, int columnCount) {
    final runes = text.runes;
    final fontSize = style.fontSize!;
    final charWidth = fontSize + space;

    for (int y = 0; y < columnCount; y++) {
      final charIndex = x * columnCount + y;
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
          (size.width - charWidth - x * charWidth).toDouble(),
          (y * fontSize).toDouble(),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
