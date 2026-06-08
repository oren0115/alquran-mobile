import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_theme.dart';
import '../utils/arabic_numerals.dart';
import 'q_card.dart';

class AyatCard extends StatelessWidget {
  const AyatCard({
    super.key,
    required this.nomorAyat,
    required this.teksArab,
    required this.teksIndonesia,
    this.teksLatin,
    this.title,
    this.onTap,
    this.isHighlighted = false,
    this.isPlaying = false,
    this.isLoading = false,
    this.onPlay,
    this.isBookmarked = false,
    this.onBookmark,
    this.onDelete,
    this.maxArabLines,
    this.maxIndonesiaLines,
  });

  final int nomorAyat;
  final String? title;
  final String teksArab;
  final String teksIndonesia;
  final String? teksLatin;
  final VoidCallback? onTap;
  final bool isHighlighted;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback? onPlay;
  final bool isBookmarked;
  final VoidCallback? onBookmark;
  final VoidCallback? onDelete;
  final int? maxArabLines;
  final int? maxIndonesiaLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final highlighted = isHighlighted || isPlaying;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          teksArab,
          style: AppTheme.arabicTextStyle(
            fontSize: 22,
            color: highlighted
                ? AppColors.emeraldDark
                : (isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary),
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          maxLines: maxArabLines,
          overflow: maxArabLines != null ? TextOverflow.ellipsis : null,
        ),
        if (teksLatin != null && teksLatin!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            teksLatin!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: 12,
              color: AppColors.gold,
            ),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          teksIndonesia,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            height: 1.5,
            color: highlighted
                ? AppColors.emerald
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary),
          ),
          maxLines: maxIndonesiaLines,
          overflow:
              maxIndonesiaLines != null ? TextOverflow.ellipsis : null,
        ),
      ],
    );

    return QCard(
      variant: highlighted ? QCardVariant.green : QCardVariant.normal,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (onBookmark != null)
                    _ActionIcon(
                      icon: isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      onPressed: onBookmark,
                    ),
                  if (onPlay != null)
                    _ActionIcon(
                      isLoading: isLoading,
                      icon: isPlaying ? Icons.volume_up : Icons.volume_up_outlined,
                      onPressed: isLoading ? null : onPlay,
                    ),
                  if (onDelete != null)
                    _ActionIcon(
                      icon: Icons.delete_outline,
                      onPressed: onDelete,
                    ),
                ],
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: highlighted
                      ? AppColors.emeraldMedium
                      : (isDark
                          ? AppColors.emeraldDark.withValues(alpha: 0.5)
                          : AppColors.emeraldLight),
                  shape: BoxShape.circle,
                  border: highlighted
                      ? null
                      : Border.all(
                          color: AppColors.emeraldMedium,
                          width: 0.5,
                        ),
                ),
                alignment: Alignment.center,
                child: Text(
                  ArabicNumerals.fromInt(nomorAyat),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: highlighted
                        ? AppColors.emeraldLight
                        : AppColors.emeraldDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (onTap != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: content,
                ),
              ),
            )
          else
            content,
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    this.onPressed,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.emerald,
                    ),
                  )
                : Icon(icon, size: 20, color: AppColors.emerald),
          ),
        ),
      ),
    );
  }
}
