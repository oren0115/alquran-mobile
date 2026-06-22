import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/bookmark_cubit.dart';
import '../../cubit/bookmark_state.dart';
import '../../cubit/settings_cubit.dart';
import '../../cubit/settings_state.dart';
import '../../cubit/surah_cubit.dart';
import '../../cubit/surah_state.dart';
import '../../models/surah.dart';
import '../../services/settings_service.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/page_header.dart';
import '../widgets/q_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, this.embedded = false});

  final bool embedded;

  String? _surahName(List<Surah>? list, int? nomor) {
    if (nomor == null || list == null) return null;
    for (final s in list) {
      if (s.nomor == nomor) return s.namaLatin;
    }
    return null;
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'P';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        return BlocBuilder<SurahCubit, SurahState>(
          builder: (context, surahState) {
            return BlocBuilder<BookmarkCubit, BookmarkState>(
              builder: (context, bookmarkState) {
                final surahList = surahState.status == SurahStatus.loaded
                    ? surahState.surahList
                    : null;
                final bookmarkCount = bookmarkState.bookmarks.length;
                final readCount = settings.lastReadSurah ?? 0;

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  children: [
                    QCard(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.emeraldLight,
                            child: Text(
                              _initials(AppText.defaultUserName),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.emeraldDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppText.defaultUserName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  AppText.joinedSince,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    QCard(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          StatItem(
                            value: '$readCount',
                            label: AppText.statSurahRead,
                          ),
                          StatItem(
                            value: '$bookmarkCount',
                            label: AppText.statBookmark,
                          ),
                          const StatItem(value: '7', label: AppText.statStreak),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const SectionTitle(title: AppText.audioSettings),
                    QCard(
                      child: DropdownButtonFormField<String>(
                        initialValue: settings.qari,
                        isExpanded: true,
                        isDense: true,
                        decoration: const InputDecoration(
                          labelText: AppText.qari,
                          labelStyle: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                        ),
                        items: qariLabels.entries
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(
                                  e.value,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            context.read<SettingsCubit>().setQari(v);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const SectionTitle(title: AppText.generalSettings),
                    if (settings.lastReadSurah != null)
                      QCard(
                        onTap: () => AppRoutes.goToDetailSurah(
                          context,
                          settings.lastReadSurah!,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.history,
                              color: AppColors.emerald,
                              size: 22,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    AppText.lastRead,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    _surahName(
                                          surahList,
                                          settings.lastReadSurah,
                                        ) ??
                                        'Surah ${settings.lastReadSurah}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.muted,
                            ),
                          ],
                        ),
                      ),
                    if (settings.lastReadSurah != null)
                      const SizedBox(height: AppSpacing.xs),
                    QCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.emerald,
                            size: 22,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  AppText.about,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  AppText.aboutDesc,
                                  style: const TextStyle(
                                    color: AppColors.muted,
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
                );
              },
            );
          },
        );
      },
    );

    if (embedded) {
      return ColoredBox(
        color: AppColors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageHeader(title: AppText.profil),
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
