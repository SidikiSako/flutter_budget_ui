import 'dart:math';

import 'package:flutter/material.dart';

class RadialPainter extends CustomPainter {
  final Color bgColor;
  final Color lineColor;
  final double percent;
  final double width;

  RadialPainter({this.bgColor, this.lineColor, this.percent, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint bgLine = Paint();
    bgLine.color = bgColor;
    bgLine.strokeCap = StrokeCap.round;
    bgLine.style = PaintingStyle.stroke;
    bgLine.strokeWidth = width;

    //une autre façon d'initialiser plusieurs paramètres d'une variable
    Paint completeLine = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    //on determine le centre de notre painter
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    //on va dessiner notre background line
    canvas.drawCircle(center, radius, bgLine);

    //on dessine l'arc qui determine nos dépenses
    double sweepAngle = 2 * pi * percent;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        sweepAngle, false, completeLine);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // parce que la radialPainter se rebuild si les données changent
    //si l'utilisateur ajoute une nouvelle depense, le RadialPainter va se redessiner tout seul
  }
}
