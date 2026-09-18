import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [Color(0xFFE7F6F1), Color(0xFFF5F8FD), Color(0xFFEFEAFE)],
      stops: [0, 0.55, 1],
    )),
    child: child,
  );
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(22), this.tint, this.radius = 28});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? tint;
  final double radius;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [BoxShadow(color: Color(0x0D304F68), blurRadius: 30, offset: Offset(0, 12))],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [(tint ?? Colors.white).withValues(alpha: 0.9), (tint ?? Colors.white).withValues(alpha: 0.6)],
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.95), width: 1.5),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
      if (subtitle != null) ...[
        const SizedBox(height: 6),
        Text(subtitle!, style: const TextStyle(color: AppColors.muted, height: 1.5)),
      ],
    ],
  );
}
