import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/audio_cubit.dart';
import '../../cubit/audio_state.dart';
import '../../cubit/detail_surah_cubit.dart';
import '../../cubit/detail_surah_state.dart';
import '../../cubit/settings_cubit.dart';
import '../../cubit/settings_state.dart';
import '../../models/ayat.dart';
import '../../models/surah.dart';
import '../../services/helpers.dart';
import '../../services/settings_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';
import '../widgets/app_topbar.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/page_header.dart';
import '../widgets/q_card.dart';

class MurottalPage extends StatelessWidget {
  const MurottalPage({super.key, required this.nomorSurah});

  final int nomorSurah;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppTopBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.emeraldSubtext,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: AppText.murottal,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.download_outlined,
                  color: AppColors.emeraldSubtext,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<DetailSurahCubit, DetailSurahState>(
              builder: (context, detailState) {
                if (detailState.status == DetailSurahStatus.loading ||
                    detailState.status == DetailSurahStatus.initial) {
                  return const LoadingWidget();
                }
                if (detailState.status == DetailSurahStatus.error) {
                  return AppErrorWidget(
                    message: Helpers.extractErrorMessage(
                      detailState.errorMessage ?? 'Error',
                    ),
                    onRetry: () =>
                        context.read<DetailSurahCubit>().refresh(),
                  );
                }

                final surah = detailState.surah!;

                return BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settings) {
                    return BlocBuilder<AudioCubit, AudioState>(
                      builder: (context, audioState) {
                        final player = context.read<AudioCubit>().player;
                        Ayat currentAyat = surah.ayat.first;
                        if (audioState.current != null) {
                          for (final a in surah.ayat) {
                            if (a.nomorAyat == audioState.current!.ayat) {
                              currentAyat = a;
                              break;
                            }
                          }
                        }

                        return ListView(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          children: [
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: AppColors.emeraldLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.emeraldMedium,
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.menu_book_outlined,
                                    size: 36,
                                    color: AppColors.emerald,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    surah.namaLatin,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.emeraldDark,
                                    ),
                                  ),
                                  Text(
                                    surah.nama,
                                    style: AppTheme.arabicTextStyle(
                                      fontSize: 14,
                                      color: AppColors.emerald,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            QCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    AppText.qariLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: settings.qari,
                                      items: qariLabels.entries
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e.key,
                                              child: Text(e.value),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) {
                                        if (v != null) {
                                          context
                                              .read<SettingsCubit>()
                                              .setQari(v);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            QCard(
                              child: Column(
                                children: [
                                  StreamBuilder<Duration>(
                                    stream: player.positionStream,
                                    builder: (context, posSnap) {
                                      final pos =
                                          posSnap.data ?? Duration.zero;
                                      final dur =
                                          player.duration ?? Duration.zero;
                                      final progress = dur.inMilliseconds > 0
                                          ? pos.inMilliseconds /
                                              dur.inMilliseconds
                                          : 0.0;

                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                audioState.current != null
                                                    ? 'Ayah ${audioState.current!.ayat} / ${surah.jumlahAyat}'
                                                    : 'Ayah - / ${surah.jumlahAyat}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                              Text(
                                                '${_fmt(pos)} / ${_fmt(dur)}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: AppSpacing.xs,
                                          ),
                                          QProgressBar(progress: progress),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.replay,
                                          color: AppColors.emerald,
                                        ),
                                        onPressed: () =>
                                            player.seek(Duration.zero),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.skip_previous,
                                          color: AppColors.emerald,
                                        ),
                                        onPressed: () => _prevAyat(
                                          context,
                                          surah,
                                          settings.qari,
                                        ),
                                      ),
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                          color: AppColors.emerald,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            audioState.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: AppColors.emeraldLight,
                                          ),
                                          onPressed: () => _togglePlay(
                                            context,
                                            currentAyat,
                                            settings.qari,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.skip_next,
                                          color: AppColors.emerald,
                                        ),
                                        onPressed: () => _nextAyat(
                                          context,
                                          surah,
                                          settings.qari,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.repeat,
                                          color: AppColors.emerald,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (audioState.current != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              QCard(
                                variant: QCardVariant.gold,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      AppText.nowPlaying,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentAyat.teksArab,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      style: AppTheme.arabicTextStyle(
                                        fontSize: 18,
                                        color: AppColors.goldDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentAyat.teksIndonesia,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.sm),
                            const SectionTitle(title: AppText.surahListTitle),
                            QCard(
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: AppColors.emeraldLight,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppColors.emeraldMedium,
                                        width: 0.5,
                                      ),
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
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      surah.namaLatin,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _fmt(player.duration ?? Duration.zero),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.muted,
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
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(1, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _togglePlay(
    BuildContext context,
    Ayat ayat,
    String qari,
  ) async {
    final error =
        await context.read<AudioCubit>().toggleAyat(ayat, qari);
    if (!context.mounted || error == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  Future<void> _prevAyat(
    BuildContext context,
    DetailSurah surah,
    String qari,
  ) async {
    final current = context.read<AudioCubit>().state.current;
    final nomor = (current?.ayat ?? 2) - 1;
    if (nomor < 1) return;
    final ayat = surah.ayat[nomor - 1];
    await context.read<AudioCubit>().toggleAyat(ayat, qari);
  }

  Future<void> _nextAyat(
    BuildContext context,
    DetailSurah surah,
    String qari,
  ) async {
    final current = context.read<AudioCubit>().state.current;
    final nomor = (current?.ayat ?? 0) + 1;
    if (nomor > surah.ayat.length) return;
    final ayat = surah.ayat[nomor - 1];
    await context.read<AudioCubit>().toggleAyat(ayat, qari);
  }
}
