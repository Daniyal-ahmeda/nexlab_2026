import 'package:flutter/material.dart';

class NexLabLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final double size;
  final Color? color;
  final bool useFullLogo;
  final bool isWhite;
  final bool showText;
  final double fontSize;
  final Color? textColor;

  const NexLabLogo({
    super.key,
    this.height,
    this.width,
    this.size = 40,
    this.color,
    this.useFullLogo = true,
    this.isWhite = false,
    this.showText = false,
    this.fontSize = 20,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final effectiveIsWhite = isWhite || (isDarkMode && color == null);

    // Determine asset path
    final String assetPath;
    if (useFullLogo || showText) {
      if (color != null) {
        assetPath = 'assets/logo_white.png';
      } else if (effectiveIsWhite) {
        assetPath = 'assets/logo_white.png';
      } else {
        assetPath = 'assets/logo_dark.png';
      }
    } else {
      if (color != null) {
        assetPath = 'assets/logo_icon_white.png';
      } else if (effectiveIsWhite) {
        assetPath = 'assets/logo_icon_white.png';
      } else {
        assetPath = 'assets/logo_icon_dark.png';
      }
    }

    final effectiveHeight = height ?? (useFullLogo || showText ? size * 0.9 : size);
    final effectiveWidth = width ?? ((useFullLogo || showText) ? effectiveHeight * 4.25 : effectiveHeight);

    Widget imageWidget = Image.asset(
      assetPath,
      height: effectiveHeight,
      width: effectiveWidth,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color != null ? BlendMode.srcIn : null,
      errorBuilder: (context, error, stackTrace) {
        // Safe fallback if asset loading encounters an issue
        return _buildFallback(context, effectiveHeight, effectiveWidth, effectiveIsWhite);
      },
    );

    return imageWidget;
  }

  Widget _buildFallback(BuildContext context, double h, double w, bool white) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: h,
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFF1E6DFB),
            borderRadius: BorderRadius.circular(h * 0.25),
          ),
          child: Center(
            child: Icon(
              Icons.biotech_rounded,
              color: Colors.white,
              size: h * 0.6,
            ),
          ),
        ),
        if (useFullLogo || showText) ...[
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: h * 0.55,
                fontWeight: FontWeight.w800,
                fontFamily: 'Outfit',
                color: white ? Colors.white : const Color(0xFF0F172A),
                letterSpacing: 0.5,
              ),
              children: const [
                TextSpan(
                  text: 'nex',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                TextSpan(
                  text: 'Lab',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
