import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/app_theme.dart';
import 'app_surface_card.dart';

class AyatCard extends StatelessWidget {
  const AyatCard({
    super.key,
    required this.nomorAyat,
    required this.title,
    required this.teksArab,
    required this.teksIndonesia,
    this.teksLatin,
    this.onTap,
    this.isPlaying = false,
    this.isLoading = false,
    this.onPlay,
    this.isBookmarked = false,
    this.onBookmark,
    this.onShare,
    this.onDelete,
    this.maxArabLines,
    this.maxIndonesiaLines,
  });

  final int nomorAyat;
  final String title;
  final String teksArab;
  final String teksIndonesia;
  final String? teksLatin;
  final VoidCallback? onTap;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback? onPlay;
  final bool isBookmarked;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final int? maxArabLines;
  final int? maxIndonesiaLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return AppSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$nomorAyat',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onPlay != null)
                _ActionIcon(
                  isLoading: isLoading,
                  icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  onPressed: isLoading ? null : onPlay,
                  tooltip: 'Putar murottal',
                ),
              if (onBookmark != null)
                _ActionIcon(
                  icon: isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  onPressed: onBookmark,
                ),
              if (onShare != null)
                _ActionIcon(
                  icon: Icons.share_outlined,
                  onPressed: onShare,
                ),
              if (onDelete != null)
                _ActionIcon(
                  icon: Icons.delete_outline_rounded,
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: Text(
              teksArab,
              style: AppTheme.arabicTextStyle(fontSize: 26),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: maxArabLines,
              overflow: maxArabLines != null ? TextOverflow.ellipsis : null,
            ),
          ),
          if (teksLatin != null && teksLatin!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              teksLatin!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: theme.colorScheme.secondary.withValues(alpha: 0.85),
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text(
            teksIndonesia,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              height: 1.45,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: maxIndonesiaLines,
            overflow:
                maxIndonesiaLines != null ? TextOverflow.ellipsis : null,
          ),
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
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return IconButton(
      icon: isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primary,
              ),
            )
          : Icon(icon, size: 22),
      onPressed: onPressed,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(AppSpacing.xs),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}
