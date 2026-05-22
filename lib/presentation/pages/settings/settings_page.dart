import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../domain/entities/surah_entity.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/detail_surah_provider.dart';
import '../../providers/surah_provider.dart';
import '../../routes/app_routes.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  String? _surahName(List<SurahEntity>? list, int? nomor) {
    if (nomor == null || list == null) return null;
    for (final s in list) {
      if (s.nomor == nomor) return s.namaLatin;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final surahList = ref.watch(surahListProvider).value;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final muted =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final lastReadName = _surahName(surahList, settings.lastReadSurah);

    return Scaffold(
      appBar: AppBar(title: const Text(AppText.settings)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        children: [
          const SectionHeader(
            title: AppText.sectionAppearance,
            topPadding: AppSpacing.sm,
          ),
          AppSurfaceCard(
            animatePress: false,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              title: Text(
                AppText.darkMode,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                AppText.darkModeSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: 12,
                ),
              ),
              value: settings.isDarkMode,
              onChanged: (v) =>
                  ref.read(settingsProvider.notifier).setDarkMode(v),
            ),
          ),
          const SectionHeader(title: AppText.sectionAudio),
          AppSurfaceCard(
            animatePress: false,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: DropdownButtonFormField<String>(
              initialValue: settings.qari,
              isDense: true,
              decoration: InputDecoration(
                labelText: AppText.qari,
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: muted,
                  fontSize: 12,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  borderSide: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.divider,
                  ),
                ),
              ),
              items: qariLabels.entries
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(
                        e.value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  ref.read(settingsProvider.notifier).setQari(v);
                }
              },
            ),
          ),
          if (settings.lastReadSurah != null) ...[
            const SectionHeader(title: AppText.sectionReading),
            AppSurfaceCard(
              onTap: () => AppRoutes.goToDetailSurah(
                context,
                settings.lastReadSurah!,
              ),
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppText.lastRead,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          lastReadName ??
                              'Surah ${settings.lastReadSurah}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: muted,
                            fontSize: 12,
                          ),
                        ),
                        if (settings.lastReadAyat != null)
                          Text(
                            'Ayat ${settings.lastReadAyat}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.75),
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: muted.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ],
          const SectionHeader(title: AppText.sectionAbout),
          AppSurfaceCard(
            animatePress: false,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: theme.colorScheme.primary.withValues(alpha: 0.85),
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppText.about,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppText.aboutDesc,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: muted,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
