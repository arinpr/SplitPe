import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Interactive liquid mesh background with subtle animated caustic light orbs
class LiquidMeshBackground extends StatefulWidget {
  const LiquidMeshBackground({super.key, required this.child});
  final Widget child;

  @override
  State<LiquidMeshBackground> createState() => _LiquidMeshBackgroundState();
}

class _LiquidMeshBackgroundState extends State<LiquidMeshBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
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
        final progress = _controller.value;
        final dx = math.sin(progress * 2 * math.pi) * 35;
        final dy = math.cos(progress * 2 * math.pi) * 25;

        return Stack(
          children: [
            // Ambient light canvas gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF3F8FB),
                    Color(0xFFEBF5F6),
                    Color(0xFFF6F7FD),
                    Color(0xFFF0FBF7),
                  ],
                  stops: [0.0, 0.35, 0.72, 1.0],
                ),
              ),
            ),
            // Floating liquid caustic orb 1 (Mint / Emerald)
            Positioned(
              top: -80 + dy,
              left: -60 + dx,
              width: 320,
              height: 320,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6EE7B7).withValues(alpha: 0.38),
                  ),
                ),
              ),
            ),
            // Floating liquid caustic orb 2 (Sky / Cyan)
            Positioned(
              top: 220 - dy * 0.8,
              right: -70 - dx,
              width: 300,
              height: 300,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.28),
                  ),
                ),
              ),
            ),
            // Floating liquid caustic orb 3 (Lavender / Violet sheen)
            Positioned(
              bottom: 80 + dy * 0.6,
              left: 40 - dx * 0.5,
              width: 280,
              height: 280,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFC084FC).withValues(alpha: 0.22),
                  ),
                ),
              ),
            ),
            // Content
            widget.child,
          ],
        );
      },
      child: widget.child,
    );
  }
}

/// Faithful Flutter implementation of Kyant0/AndroidLiquidGlass
/// Featuring dual-pass optical blur, chromatic dispersion rim border,
/// directional specular highlight sheen, and interactive touch spotlight.
class LiquidGlassCard extends StatefulWidget {
  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 26,
    this.blurSigma = 18,
    this.tint,
    this.enableInteractiveSheen = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blurSigma;
  final Color? tint;
  final bool enableInteractiveSheen;
  final VoidCallback? onTap;

  @override
  State<LiquidGlassCard> createState() => _LiquidGlassCardState();
}

class _LiquidGlassCardState extends State<LiquidGlassCard>
    with SingleTickerProviderStateMixin {
  Offset? _touchPosition;
  late final AnimationController _sheenFadeController;

  @override
  void initState() {
    super.initState();
    _sheenFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _sheenFadeController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!widget.enableInteractiveSheen) return;
    setState(() {
      _touchPosition = event.localPosition;
    });
    _sheenFadeController.value = 1.0;
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!widget.enableInteractiveSheen) return;
    setState(() {
      _touchPosition = event.localPosition;
    });
    _sheenFadeController.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!widget.enableInteractiveSheen) return;
    _sheenFadeController.reverse();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (!widget.enableInteractiveSheen) return;
    _sheenFadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTint = widget.tint ?? Colors.white;

    final content = Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: Stack(
        children: [
          // Base glass container
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              boxShadow: [
                // Ambient soft liquid drop shadow
                BoxShadow(
                  color: const Color(0xFF0F3E50).withValues(alpha: 0.07),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                  spreadRadius: -4,
                ),
                // Crisp contact shadow
                BoxShadow(
                  color: const Color(0xFF0F3E50).withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.blurSigma,
                  sigmaY: widget.blurSigma,
                ),
                child: CustomPaint(
                  foregroundPainter: _LiquidGlassSpecularPainter(
                    radius: widget.radius,
                    touchPosition: _touchPosition,
                    sheenOpacity: _sheenFadeController,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.radius),
                      // Liquid refraction base tint
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          effectiveTint.withValues(alpha: 0.88),
                          effectiveTint.withValues(alpha: 0.62),
                          effectiveTint.withValues(alpha: 0.74),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                      // Specular dispersion bevel rim
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.85),
                        width: 1.5,
                      ),
                    ),
                    padding: widget.padding,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}

/// Custom painter rendering specular rim highlights and touch-reactive lens refraction
class _LiquidGlassSpecularPainter extends CustomPainter {
  _LiquidGlassSpecularPainter({
    required this.radius,
    required this.touchPosition,
    required this.sheenOpacity,
  }) : super(repaint: sheenOpacity);

  final double radius;
  final Offset? touchPosition;
  final Animation<double> sheenOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    // 1. Directional top-left specular highlight rim (simulating glass edge reflection)
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.95),
          Colors.white.withValues(alpha: 0.40),
          const Color(0xFFC7EBF2).withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.10),
        ],
        stops: const [0.0, 0.35, 0.70, 1.0],
      ).createShader(rect);

    canvas.drawRRect(rrect, rimPaint);

    // 2. Subtle top diagonal gloss shimmer
    final glossPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(0, size.height * 0.65)
      ..close();

    final glossPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.16),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(rect);

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawPath(glossPath, glossPaint);

    // 3. Interactive touch spotlight / refraction glow
    if (touchPosition != null && sheenOpacity.value > 0.01) {
      final spotlightPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = RadialGradient(
          center: Alignment(
            (touchPosition!.dx / size.width) * 2 - 1,
            (touchPosition!.dy / size.height) * 2 - 1,
          ),
          radius: 0.65,
          colors: [
            Colors.white.withValues(alpha: 0.28 * sheenOpacity.value),
            const Color(0xFF38BDF8).withValues(alpha: 0.12 * sheenOpacity.value),
            Colors.transparent,
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(rect);

      canvas.drawRRect(rrect, spotlightPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LiquidGlassSpecularPainter oldDelegate) {
    return oldDelegate.touchPosition != touchPosition ||
        oldDelegate.sheenOpacity.value != sheenOpacity.value;
  }
}

/// Liquid spring button mirroring Kyant0/AndroidLiquidGlass `LiquidButton`
/// Features spring physics, velocity squash & stretch, and liquid gloss sheen
class LiquidSpringButton extends StatefulWidget {
  const LiquidSpringButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
    this.borderRadius = 22,
    this.isFullWidth = false,
    this.elevation = 6,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool isFullWidth;
  final double elevation;

  @override
  State<LiquidSpringButton> createState() => _LiquidSpringButtonState();
}

class _LiquidSpringButtonState extends State<LiquidSpringButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _springController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _squashAnimation;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    // Spring compress on press, overshoot slightly on release
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.94)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.94, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_springController);

    // Dynamic squash and stretch: expands slightly horizontally when pressed
    _squashAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _springController, curve: Curves.easeOutQuad),
    );
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    HapticFeedback.lightImpact();
    _springController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    _springController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    _springController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? AppColors.primary;
    final fg = widget.foregroundColor ?? Colors.white;

    final btnBody = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            bg,
            Color.lerp(bg, const Color(0xFF044842), 0.18) ?? bg,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.36),
            blurRadius: widget.elevation * 3.2,
            offset: Offset(0, widget.elevation * 1.4),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.4),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Specular top gloss capsule
          Positioned(
            top: 1,
            left: 12,
            right: 12,
            height: 14,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.35),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          DefaultTextStyle(
            style: TextStyle(
              color: fg,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
            child: IconTheme(
              data: IconThemeData(color: fg, size: 20),
              child: widget.child,
            ),
          ),
        ],
      ),
    );

    return AnimatedBuilder(
      animation: _springController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(
            _scaleAnimation.value * _squashAnimation.value,
            _scaleAnimation.value * (2.0 - _squashAnimation.value),
            1.0,
          ),
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            behavior: HitTestBehavior.opaque,
            child: widget.isFullWidth
                ? SizedBox(width: double.infinity, child: btnBody)
                : btnBody,
          ),
        );
      },
    );
  }
}

/// Modern floating bottom dock replicating `LiquidBottomTabs` & `DampedDragAnimation`
/// from Kyant0/AndroidLiquidGlass.
/// Displays a smooth floating capsule dock with an animated liquid indicator pill
/// that squashes and stretches as it glides between tabs.
class LiquidBottomTabs extends StatefulWidget {
  const LiquidBottomTabs({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<LiquidTabItem> items;

  @override
  State<LiquidBottomTabs> createState() => _LiquidBottomTabsState();
}

class LiquidTabItem {
  const LiquidTabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _LiquidBottomTabsState extends State<LiquidBottomTabs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  int _targetIndex = 0;
  int _prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _targetIndex = widget.currentIndex;
    _prevIndex = widget.currentIndex;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
  }

  @override
  void didUpdateWidget(covariant LiquidBottomTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _prevIndex = oldWidget.currentIndex;
      _targetIndex = widget.currentIndex;
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, math.max(bottomInset, 16)),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0C2B38).withValues(alpha: 0.12),
              blurRadius: 36,
              offset: const Offset(0, 16),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.92),
                    const Color(0xFFF0F7FA).withValues(alpha: 0.82),
                    Colors.white.withValues(alpha: 0.88),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.95),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final tabCount = widget.items.length;
                  final tabWidth = constraints.maxWidth / tabCount;

                  return AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      // Elastic spring interpolation for liquid sliding pill
                      final curve = CurvedAnimation(
                        parent: _animController,
                        curve: Curves.easeOutBack,
                      );

                      final currentPos = _animController.isAnimating
                          ? lerpDouble(
                              _prevIndex.toDouble(),
                              _targetIndex.toDouble(),
                              curve.value,
                            )!
                          : widget.currentIndex.toDouble();

                      // Dynamic stretch factor: pill elongates during movement
                      final stretch = _animController.isAnimating
                          ? (1.0 + (math.sin(_animController.value * math.pi) * 0.16))
                          : 1.0;

                      final pillLeft = (currentPos * tabWidth) +
                          (tabWidth * (1.0 - stretch) / 2);
                      final pillWidth = tabWidth * stretch;

                      return Stack(
                        children: [
                          // Sliding liquid indicator pill
                          Positioned(
                            left: pillLeft.clamp(
                              0.0,
                              constraints.maxWidth - (tabWidth * 0.8),
                            ),
                            top: 0,
                            bottom: 0,
                            width: pillWidth,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF087F75),
                                    Color(0xFF0D9488),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF087F75)
                                        .withValues(alpha: 0.38),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                          // Tab items
                          Row(
                            children: List.generate(tabCount, (index) {
                              final item = widget.items[index];
                              final isSelected = widget.currentIndex == index;

                              return Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (widget.currentIndex != index) {
                                      HapticFeedback.selectionClick();
                                      widget.onTap(index);
                                    }
                                  },
                                  child: Center(
                                    child: AnimatedScale(
                                      scale: isSelected ? 1.05 : 0.95,
                                      duration:
                                          const Duration(milliseconds: 220),
                                      curve: Curves.easeOutBack,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isSelected
                                                ? item.selectedIcon
                                                : item.icon,
                                            size: 22,
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.muted,
                                          ),
                                          const SizedBox(height: 3),
                                          AnimatedDefaultTextStyle(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.muted,
                                              letterSpacing: -0.2,
                                            ),
                                            child: Text(item.label),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
