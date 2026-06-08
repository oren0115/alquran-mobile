import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/app_topbar.dart';
import '../../../core/widgets/q_card.dart';
import '../../../domain/entities/surah_entity.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/detail_surah_provider.dart';
import '../../providers/surah_provider.dart';
import '../../routes/app_routes.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key, this.embedded = false});

  final bool embedded;

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

    final content = ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        QCard(
          child: DropdownButtonFormField<String>(
            initialValue: settings.qari,
            isDense: true,
            decoration: InputDecoration(
              labelText: AppText.qari,
              labelStyle: TextStyle(color: muted, fontSize: 12),
              border: InputBorder.none,
            ),
            items: qariLabels.entries
                .map(
                  (e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value, style: const TextStyle(fontSize: 14)),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) ref.read(settingsProvider.notifier).setQari(v);
            },
          ),
        ),
        if (settings.lastReadSurah != null) ...[
          const SizedBox(height: AppSpacing.xs),
          QCard(
            variant: QCardVariant.green,
            onTap: () => AppRoutes.goToDetailSurah(
              context,
              settings.lastReadSurah!,
            ),
            child: Row(
              children: [
                const Icon(Icons.history, color: AppColors.emerald),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppText.lastRead,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.emeraldDark,
                        ),
                      ),
                      Text(
                        lastReadName ?? 'Surah ${settings.lastReadSurah}',
                        style: TextStyle(fontSize: 12, color: AppColors.emerald),
                      ),
                      if (settings.lastReadAyat != null)
                        Text(
                          'Ayat ${settings.lastReadAyat}',
                          style: TextStyle(fontSize: 12, color: AppColors.emerald),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: muted),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xs),
        QCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.emerald, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.about,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppText.aboutDesc,
                      style: TextStyle(color: muted, fontSize: 13, height: 1.45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (embedded) {
      return ColoredBox(
        color: AppColors.background,
        child: Column(
          children: [
            const AppTopBar(title: AppText.profil),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppText.settings)),
      body: content,
    );
  }
}
