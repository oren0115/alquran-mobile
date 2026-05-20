import 'package:flutter/material.dart';

import '../../domain/entities/surah_entity.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_theme.dart';
import '../utils/formatter.dart';
import 'app_surface_card.dart';

class SurahCard extends StatelessWidget {
  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
    this.compact = false,
  });

  final SurahEntity surah;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final numberSize = compact ? 38.0 : 40.0;

    return AppSurfaceCard(
      onTap: onTap,
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: compact ? 3 : 4,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: compact ? AppSpacing.sm : AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Container(
            width: numberSize,
            height: numberSize,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${surah.nomor}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
                fontSize: compact ? 13 : 14,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah.namaLatin,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: compact ? 16 : 18,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: compact ? 2 : 4),
                Text(
                  Formatter.surahSubtitle(
                    tempatTurun: surah.tempatTurun,
                    jumlahAyat: surah.jumlahAyat,
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: compact ? 1 : 2),
                Text(
                  surah.arti,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: primary.withValues(alpha: 0.75),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              right: AppSpacing.xs,
            ),
            child: Text(
              surah.nama,
              style: AppTheme.arabicTextStyle(
                fontSize: compact ? 22 : 26,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}
