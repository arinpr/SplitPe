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
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF087F75).withValues(alpha: 0.20),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            'assets/images/logo.png',
            width: 44,
            height: 44,
            fit: BoxFit.contain,
          ),
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
