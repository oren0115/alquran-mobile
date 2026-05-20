import 'package:flutter/material.dart';

import '../../domain/entities/surah_entity.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_theme.dart';
import '../utils/formatter.dart';
import 'app_surface_card.dart';

class SurahHeaderBanner extends StatelessWidget {
  const SurahHeaderBanner({
    super.key,
    required this.namaArab,
    required this.arti,
    required this.jumlahAyat,
    required this.tempatTurun,
  });

  final String namaArab;
  final String arti;
  final int jumlahAyat;
  final String tempatTurun;

  factory SurahHeaderBanner.fromDetail(DetailSurahEntity surah) {
    return SurahHeaderBanner(
      namaArab: surah.nama,
      arti: surah.arti,
      jumlahAyat: surah.jumlahAyat,
      tempatTurun: surah.tempatTurun,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final muted =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return AppSurfaceCard(
      animatePress: false,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          Text(
            namaArab,
            style: AppTheme.arabicTextStyle(
              fontSize: 34,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            arti,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            Formatter.surahSubtitle(
              tempatTurun: tempatTurun,
              jumlahAyat: jumlahAyat,
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: muted,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
