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
    return LayoutBuilder(
      builder: (context, constraints) {
        final mergeStyle = DefaultTextStyle.of(context).style.merge(style);
        final charWidth = mergeStyle.fontSize! + space;
        final height = constraints.maxHeight - 4;
        final squareCountList = _calcSquareCount(mergeStyle, height);

        return RepaintBoundary(
          child: CustomPaint(
            size: Size(squareCountList.length * charWidth, height),
            painter: _TategakiPainter(text, mergeStyle, space, squareCountList),
          ),
        );
      },
    );
  }

  List<int> _calcSquareCount(TextStyle style, double height) {
    final columnSquareCount = height ~/ style.fontSize!;
    int i = 0;
    List<int> countList = [];

    for (int rune in text.runes) {
      final isNextLast = i == columnSquareCount - 1;
      final isNextLF = rune == '\n'.runes.first;

      if (isNextLF && i != 0) {
        countList.add(i);
        i = 0;
      } else if (isNextLast) {
        countList.add(i + 1);
        i = 0;
      } else {
        i++;
      }
    }
    countList.add(i);

    return countList;
  }
}

class _TategakiPainter extends CustomPainter {
  _TategakiPainter(this.text, this.style, this.space, this.squareCountList);

  final String text;
  final TextStyle style;
  final double space;
  final List<int> squareCountList;

  int charIndex = 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    for (int x = 0; x < squareCountList.length; x++) {
      _drawTextLine(canvas, size, x);
    }

    canvas.restore();
  }

  void _drawTextLine(Canvas canvas, Size size, int x) {
    final runes = text.replaceAll('\n', '').runes;
    final fontSize = style.fontSize!;
    final charWidth = fontSize + space;

    for (int y = 0; y < squareCountList[x]; y++) {
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
