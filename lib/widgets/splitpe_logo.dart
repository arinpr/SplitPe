import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplitPeeLogo extends StatelessWidget {
  const SplitPeeLogo({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2DD4BF), Color(0xFF087F75)],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF087F75).withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 1,
              left: 3,
              right: 3,
              height: 12,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.5),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            const Icon(Icons.call_split_rounded, color: Colors.white, size: 26),
          ],
        ),
      ),
      if (!compact) ...[
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SplitPee',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                color: AppColors.ink,
              ),
            ),
            Text(
              'Smart UPI Split',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    ],
  );
}
