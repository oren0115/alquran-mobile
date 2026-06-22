import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/settings_cubit.dart';
import '../../cubit/settings_state.dart';
import '../../cubit/shalat_cubit.dart';
import '../../cubit/shalat_state.dart';
import '../../cubit/surah_cubit.dart';
import '../../cubit/surah_state.dart';
import '../../models/surah.dart';
import '../../services/formatter.dart';
import '../../services/helpers.dart';
import '../../services/juz_helper.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/page_header.dart';
import '../widgets/q_card.dart';

const _popularSurahNumbers = [1, 2, 36];

class BerandaTab extends StatelessWidget {
  const BerandaTab({
    super.key,
    required this.onNavigateToTab,
    required this.onFocusSearch,
  });

  final ValueChanged<int> onNavigateToTab;
  final VoidCallback onFocusSearch;

  Surah? _findSurah(List<Surah> list, int nomor) {
    for (final s in list) {
      if (s.nomor == nomor) return s;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(
            title: AppText.defaultUserName,
            subtitle: AppText.greeting,
          ),
          Expanded(
            child: BlocBuilder<SurahCubit, SurahState>(
              builder: (context, surahState) {
                if (surahState.status == SurahStatus.loading ||
                    surahState.status == SurahStatus.initial) {
                  return const LoadingWidget();
                }
                if (surahState.status == SurahStatus.error) {
                  return AppErrorWidget(
                    message: Helpers.extractErrorMessage(
                      surahState.errorMessage ?? 'Error',
                    ),
                    onRetry: () => context.read<SurahCubit>().refresh(),
                  );
                }

                return BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settings) {
                    final list = surahState.surahList;
                    final lastReadNomor = settings.lastReadSurah;
                    final lastReadSurah = lastReadNomor != null
                        ? _findSurah(list, lastReadNomor)
                        : null;
                    final popularSurahs = _popularSurahNumbers
                        .map((n) => _findSurah(list, n))
                        .whereType<Surah>()
                        .toList();

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.sm,
                        0,
                        AppSpacing.sm,
                        AppSpacing.md,
                      ),
                      children: [
                        BlocBuilder<ShalatCubit, ShalatState>(
                          builder: (context, shalatState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _ShalatCard(
                                  settings: settings,
                                  shalatState: shalatState,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.shalat,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                              ],
                            );
                          },
                        ),
                        if (lastReadSurah != null && lastReadNomor != null)
                          _LastReadCard(
                            surah: lastReadSurah,
                            ayat: settings.lastReadAyat ?? 1,
                            juz: JuzHelper.juzForSurah(lastReadNomor),
                            onContinue: () => AppRoutes.goToDetailSurah(
                              context,
                              lastReadNomor,
                            ),
                          ),
                        if (lastReadSurah != null)
                          const SizedBox(height: AppSpacing.sm),
                        SectionTitle(title: AppText.mainMenu),
                        Row(
                          children: [
                            Expanded(
                              child: _MenuButton(
                                icon: Icons.menu_book_outlined,
                                label: AppText.quickSurah,
                                onTap: () => onNavigateToTab(1),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: _MenuButton(
                                icon: Icons.auto_stories_outlined,
                                label: AppText.quickTafsir,
                                onTap: () => AppRoutes.goToDetailSurah(
                                  context,
                                  lastReadNomor ?? 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: _MenuButton(
                                icon: Icons.back_hand_outlined,
                                label: AppText.quickDoa,
                                onTap: () => AppRoutes.goToDoa(context),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: _MenuButton(
                                icon: Icons.headphones_outlined,
                                label: AppText.quickMurottal,
                                onTap: () => AppRoutes.goToMurottal(
                                  context,
                                  lastReadNomor ?? 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SectionTitle(
                          title: AppText.popularSurah,
                          actionLabel: AppText.seeAll,
                          onAction: () => onNavigateToTab(1),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: popularSurahs.length,
                            separatorBuilder: (_, index) =>
                                const SizedBox(width: AppSpacing.xs),
                            itemBuilder: (context, index) {
                              final surah = popularSurahs[index];
                              return _PopularSurahCard(
                                surah: surah,
                                onTap: () => AppRoutes.goToDetailSurah(
                                  context,
                                  surah.nomor,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ShalatCard extends StatelessWidget {
  const _ShalatCard({
    required this.settings,
    required this.shalatState,
    required this.onTap,
  });

  final SettingsState settings;
  final ShalatState shalatState;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final next = shalatState.nextPrayer;
    final loading =
        shalatState.status == ShalatStatus.loading &&
        shalatState.jadwal == null;
    final error =
        shalatState.status == ShalatStatus.error && shalatState.jadwal == null;

    return QCard(
      variant: QCardVariant.gold,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: loading
          ? const SizedBox(
              height: 56,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.mosque_outlined,
                      size: 18,
                      color: AppColors.goldDark.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${settings.kabkota}, ${settings.provinsi}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.goldDark.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.goldDark.withValues(alpha: 0.6),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                if (error)
                  Text(
                    AppText.errorGeneric,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.goldDark.withValues(alpha: 0.85),
                    ),
                  )
                else if (next != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppText.nextPrayer,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.goldDark.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                            ),
                            Text(
                              next.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.goldDark,
                              ),
                            ),
                            Text(
                              '± ${next.remainingLabel}',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.goldDark.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        next.time,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.goldDark,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    AppText.lihatJadwal,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.goldDark.withValues(alpha: 0.85),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _LastReadCard extends StatelessWidget {
  const _LastReadCard({
    required this.surah,
    required this.ayat,
    required this.juz,
    required this.onContinue,
  });

  final Surah surah;
  final int ayat;
  final int juz;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return QCard(
      variant: QCardVariant.green,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.lastRead,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.emerald.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.namaLatin,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emeraldDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ayat $ayat · Juz $juz',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.emerald.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlineActionButton(
                      icon: Icons.play_arrow_rounded,
                      label: AppText.continueReading,
                      onTap: onContinue,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    surah.nama,
                    style: AppTheme.arabicTextStyle(
                      fontSize: 18,
                      color: AppColors.emerald,
                      height: 1.3,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    '${surah.jumlahAyat} Ayat',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.emerald.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return QCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.emerald),
          const SizedBox(height: 4),
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

class _PopularSurahCard extends StatelessWidget {
  const _PopularSurahCard({required this.surah, required this.onTap});

  final Surah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: QCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.emeraldLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.emeraldMedium, width: 0.5),
              ),
              alignment: Alignment.center,
              child: Text(
                '${surah.nomor}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.emeraldDark,
                ),
              ),
            ),
            const Spacer(),
            Text(
              surah.namaLatin,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              Formatter.surahSubtitle(
                tempatTurun: surah.tempatTurun,
                jumlahAyat: surah.jumlahAyat,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: AppColors.muted),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                surah.nama,
                style: AppTheme.arabicTextStyle(
                  fontSize: 14,
                  color: AppColors.emerald,
                  height: 1.2,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
