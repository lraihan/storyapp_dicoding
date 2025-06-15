import 'package:flutter/material.dart';
import 'dart:math';
class WavePainter extends CustomPainter {
  final Color color;
  final double animationValue;
  WavePainter({
    required this.color,
    this.animationValue = 0.0,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    final waveHeight = size.height * 0.2;
    final waveLength = size.width;
    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height - waveHeight * (0.5 + 0.5 * sin(x / waveLength * 2 * pi + animationValue * 2 * pi));
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.color != color;
  }
}
class AnimatedWaveWidget extends StatefulWidget {
  final double height;
  final Color color;
  final Duration duration;
  const AnimatedWaveWidget({
    super.key,
    this.height = 100,
    this.color = Colors.blue,
    this.duration = const Duration(seconds: 3),
  });
  @override
  State<AnimatedWaveWidget> createState() => _AnimatedWaveWidgetState();
}
class _AnimatedWaveWidgetState extends State<AnimatedWaveWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          child: CustomPaint(
            painter: WavePainter(
              color: widget.color,
              animationValue: _controller.value,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}
class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;
  CircleProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    this.strokeWidth = 4.0,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, backgroundPaint);
    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }
  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
