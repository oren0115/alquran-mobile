import 'package:flutter/material.dart';

import '../../domain/entities/surah_entity.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_theme.dart';
import '../utils/arabic_numerals.dart';
import '../utils/formatter.dart';

/// Item daftar surah sesuai wireframe — baris dengan divider.
class SurahListTile extends StatelessWidget {
  const SurahListTile({
    super.key,
    required this.surah,
    required this.onTap,
  });

  final SurahEntity surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.emeraldDark.withValues(alpha: 0.5)
                    : AppColors.emeraldLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.emeraldMedium,
                  width: 0.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                ArabicNumerals.fromInt(surah.nomor),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.emeraldDark,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          surah.namaLatin,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        surah.nama,
                        style: AppTheme.arabicTextStyle(
                          fontSize: 16,
                          color: AppColors.emerald,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu surah untuk "lanjut membaca" di beranda.
class SurahCard extends StatelessWidget {
  const SurahCard({
    super.key,
    required this.surah,
    required this.onTap,
    this.compact = false,
    this.ayatProgress,
  });

  final SurahEntity surah;
  final VoidCallback onTap;
  final bool compact;
  final double? ayatProgress;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return SurahListTile(surah: surah, onTap: onTap);
    }

    return SurahListTile(surah: surah, onTap: onTap);
  }
}
