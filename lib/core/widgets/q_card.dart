import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

enum QCardVariant { normal, green, gold }

/// Kartu sesuai wireframe dengan border halus.
class QCard extends StatelessWidget {
  const QCard({
    super.key,
    required this.child,
    this.variant = QCardVariant.normal,
    this.onTap,
    this.padding,
    this.margin,
  });

  final Widget child;
  final QCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color borderColor;
    switch (variant) {
      case QCardVariant.green:
        bg = isDark
            ? AppColors.emeraldDark.withValues(alpha: 0.4)
            : AppColors.emeraldLight;
        borderColor =
            isDark ? AppColors.emeraldMedium : AppColors.emeraldMedium;
      case QCardVariant.gold:
        bg = isDark
            ? AppColors.goldDark.withValues(alpha: 0.3)
            : AppColors.goldLight;
        borderColor = isDark ? AppColors.goldMedium : AppColors.goldMedium;
      case QCardVariant.normal:
        bg = isDark ? AppColors.darkSurface : AppColors.surface;
        borderColor = isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.border;
    }

    final content = Container(
      margin: margin,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs + 2,
          ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: content,
      ),
    );
  }
}

/// Badge kecil hijau/emas sesuai wireframe.
class QBadge extends StatelessWidget {
  const QBadge({
    super.key,
    required this.label,
    this.variant = QCardVariant.gold,
  });

  final String label;
  final QCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final isGreen = variant == QCardVariant.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isGreen ? AppColors.emeraldLight : AppColors.goldLight,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isGreen ? AppColors.emeraldMedium : AppColors.goldMedium,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isGreen ? AppColors.emeraldDark : AppColors.goldDark,
        ),
      ),
    );
  }
}

/// Tag filter (Semua, Juz, Makkiyah, dll).
class QFilterTag extends StatelessWidget {
  const QFilterTag({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: active
              ? (isDark
                  ? AppColors.emeraldDark.withValues(alpha: 0.5)
                  : AppColors.emeraldLight)
              : (isDark ? AppColors.darkSurface : AppColors.surface),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: active ? AppColors.emeraldMedium : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active
                ? AppColors.emeraldDark
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

/// Progress bar hijau sesuai wireframe.
class QProgressBar extends StatelessWidget {
  const QProgressBar({
    super.key,
    required this.progress,
    this.height = 4,
  });

  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: AppColors.emerald.withValues(alpha: 0.15),
        valueColor: const AlwaysStoppedAnimation(AppColors.emeraldMedium),
      ),
    );
  }
}
