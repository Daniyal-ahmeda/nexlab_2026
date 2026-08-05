import 'package:flutter/material.dart';

class ResponsiveDeviceFrame extends StatelessWidget {
  final Widget child;

  const ResponsiveDeviceFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Large screen - show a premium phone frame wrapper
          return Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF020617)
                : const Color(0xFFE2E8F0),
            alignment: Alignment.center,
            child: Container(
              width: 410,
              height: 860,
              margin: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 15),
                  )
                ],
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF334155)
                      : const Color(0xFF94A3B8),
                  width: 12,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: const Size(410, 860),
                  ),
                  child: child,
                ),
              ),
            ),
          );
        } else {
          // Mobile size - show normal full screen
          return child;
        }
      },
    );
  }
}
