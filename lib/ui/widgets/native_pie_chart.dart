import 'package:flutter/material.dart';
import 'dart:math';

class NativePieChart extends StatelessWidget {
  final Map<String, double> data;

  const NativePieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Icon(Icons.pie_chart_outline, size: 100, color: Colors.grey[300]),
      );
    }
    return CustomPaint(
      size: Size(200, 200),
      painter: _PieChartPainter(data),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final Map<String, double> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    double total = data.values.fold(0, (sum, val) => sum + val);
    if (total == 0) return;

    double startAngle = -pi / 2;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    List<Color> colors = [
      Colors.redAccent, Colors.blueAccent, Colors.orangeAccent, 
      Colors.purpleAccent, Colors.teal, Colors.pinkAccent,
      Colors.amber, Colors.cyan
    ];
    int colorIndex = 0;

    data.forEach((key, value) {
      final sweepAngle = (value / total) * 2 * pi;
      final paint = Paint()
        ..color = colors[colorIndex % colors.length]
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      
      startAngle += sweepAngle;
      colorIndex++;
    });

    // Draw inner circle for Donut effect
    final innerPaint = Paint()..color = Color(0xFFF4F6F9);
    canvas.drawCircle(Offset(size.width/2, size.height/2), size.width/3, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
