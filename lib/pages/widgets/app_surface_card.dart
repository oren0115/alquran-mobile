import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Card dengan depth ringan, border halus, dan animasi tap opsional.
class AppSurfaceCard extends StatefulWidget {
  const AppSurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.animatePress = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool animatePress;

  @override
  State<AppSurfaceCard> createState() => _AppSurfaceCardState();
}

class _AppSurfaceCardState extends State<AppSurfaceCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _pressController;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.animatePress && widget.onTap != null) {
      _pressController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 180),
        reverseDuration: const Duration(milliseconds: 150),
      );
      _scaleAnimation = Tween<double>(begin: 1, end: 0.97).animate(
        CurvedAnimation(parent: _pressController!, curve: Curves.easeOutCubic),
      );
    }
  }

  @override
  void didUpdateWidget(covariant AppSurfaceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final needsAnimation = widget.animatePress && widget.onTap != null;
    if (needsAnimation && _pressController == null) {
      _pressController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 180),
        reverseDuration: const Duration(milliseconds: 150),
      );
      _scaleAnimation = Tween<double>(begin: 1, end: 0.97).animate(
        CurvedAnimation(parent: _pressController!, curve: Curves.easeOutCubic),
      );
    }
  }

  @override
  void dispose() {
    _pressController?.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _pressController?.forward();
  void _onTapUp(TapUpDetails _) => _pressController?.reverse();
  void _onTapCancel() => _pressController?.reverse();

  static BoxDecoration decoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.04);
    final gradientEnd = isDark
        ? surfaceColor.withValues(alpha: 0.92)
        : surfaceColor.withValues(alpha: 0.98);

    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [surfaceColor, gradientEnd],
      ),
      border: Border.all(color: borderColor),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.35)
              : primary.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = widget.padding ??
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
    final margin = widget.margin ??
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 4,
        );

    Widget content = Ink(
      decoration: decoration(context),
      child: Padding(padding: padding, child: widget.child),
    );

    if (widget.onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: _pressController != null ? _onTapDown : null,
          onTapUp: _pressController != null ? _onTapUp : null,
          onTapCancel: _pressController != null ? _onTapCancel : null,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          child: content,
        ),
      );
    }

    content = Padding(padding: margin, child: content);

    if (_scaleAnimation != null) {
      content = ScaleTransition(scale: _scaleAnimation!, child: content);
    }

    return content;
  }
}
