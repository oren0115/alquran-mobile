import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Header halaman tab (background terang) sesuai Figma Wireframe Kit.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        MediaQuery.paddingOf(context).top + AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Judul section (Menu Utama, Surah Populer, dll).
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.action,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (action != null)
            action!
          else if (actionLabel != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.emerald,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tombol aksi outline (Dengarkan, Bagikan, Lanjutkan).
class OutlineActionButton extends StatelessWidget {
  const OutlineActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.expanded = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: AppColors.emerald),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.emerald,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        side: const BorderSide(color: AppColors.emeraldMedium, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

/// Stat item di halaman pengaturan.
class StatItem extends StatelessWidget {
  const StatItem({
    super.key,
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.emerald,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
