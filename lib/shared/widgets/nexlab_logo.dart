import 'package:flutter/material.dart';

class NexLabLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showText;
  final double fontSize;
  final Color? textColor;

  const NexLabLogo({
    super.key,
    this.size = 40,
    this.color,
    this.showText = false,
    this.fontSize = 20,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoColor = color ?? theme.primaryColor;
    final txtColor = textColor ?? (theme.brightness == Brightness.dark ? Colors.white : Colors.black87);

    final logoMark = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(color: logoColor),
      ),
    );

    if (!showText) return logoMark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoMark,
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              fontFamily: 'Outfit',
              color: txtColor,
              letterSpacing: 0.5,
            ),
            children: const [
              TextSpan(
                text: 'nex',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: 'Lab',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;
  _LogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path();
    
    // Draw outer leaf frame
    path.moveTo(w * 0.1, h * 0.45);
    path.cubicTo(w * 0.1, h * 0.15, w * 0.4, 0, w * 0.75, 0);
    path.cubicTo(w * 0.9, 0, w, h * 0.1, w, h * 0.25);
    path.cubicTo(w, h * 0.55, w * 0.9, h * 0.85, w * 0.9, h * 0.95);
    path.cubicTo(w * 0.9, h * 0.98, w * 0.6, h, w * 0.25, h);
    path.cubicTo(w * 0.1, h, 0, h * 0.9, 0, h * 0.75);
    path.cubicTo(0, h * 0.45, w * 0.1, h * 0.15, w * 0.1, h * 0.05);
    path.close();

    // Draw inner square cut-out (subtractive path)
    final innerPath = Path();
    final double pad = w * 0.24;
    final r = Rect.fromLTWH(pad, pad, w - pad * 2, h - pad * 2);
    final rrect = RRect.fromRectAndRadius(r, Radius.circular(w * 0.12));
    innerPath.addRRect(rrect);

    final combined = Path.combine(PathOperation.difference, path, innerPath);

    canvas.drawPath(combined, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
