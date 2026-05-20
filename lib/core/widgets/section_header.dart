import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.topPadding = AppSpacing.md,
  });

  final String title;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        topPadding,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: labelColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          fontSize: 11,
        ),
      ),
    );
  }
}
