import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../../domain/entities/surah_entity.dart';

class SurahNavBar extends StatelessWidget {
  const SurahNavBar({
    super.key,
    this.sebelumnya,
    this.selanjutnya,
    required this.onPrev,
    required this.onNext,
  });

  final SurahNavEntity? sebelumnya;
  final SurahNavEntity? selanjutnya;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final prev = sebelumnya;
    final next = selanjutnya;
    if (prev == null && next == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final barColor = isDark
        ? theme.colorScheme.surface.withValues(alpha: 0.92)
        : theme.colorScheme.surface.withValues(alpha: 0.95);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: barColor,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm + bottomInset,
          ),
          child: Row(
            children: [
              if (prev != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onPrev,
                    icon: const Icon(Icons.chevron_left_rounded, size: 20),
                    label: Text(
                      prev.namaLatin,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                ),
              if (prev != null && next != null)
                const SizedBox(width: AppSpacing.xs),
              if (next != null)
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onNext,
                    icon: const Icon(Icons.chevron_right_rounded, size: 20),
                    label: Text(
                      next.namaLatin,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
