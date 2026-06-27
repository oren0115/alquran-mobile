import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/audio_cubit.dart';
import '../../cubit/audio_state.dart';
import '../../cubit/bookmark_cubit.dart';
import '../../cubit/bookmark_state.dart';
import '../../cubit/detail_surah_cubit.dart';
import '../../cubit/detail_surah_state.dart';
import '../../cubit/settings_cubit.dart';
import '../../cubit/settings_state.dart';
import '../../cubit/tafsir_cubit.dart';
import '../../cubit/tafsir_state.dart';
import '../../models/ayat.dart';
import '../../services/formatter.dart';
import '../../services/helpers.dart';
import '../../services/html_utils.dart';
import '../../services/juz_helper.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';
import '../widgets/app_topbar.dart';
import '../widgets/ayat_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/q_card.dart';

class DetailSurahPage extends StatefulWidget {
  const DetailSurahPage({super.key, required this.nomorSurah});

  final int nomorSurah;

  @override
  State<DetailSurahPage> createState() => _DetailSurahPageState();
}

class _DetailSurahPageState extends State<DetailSurahPage> {
  bool _showTafsir = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsCubit>().saveLastRead(widget.nomorSurah, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) context.read<AudioCubit>().stop();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<DetailSurahCubit, DetailSurahState>(
          builder: (context, detailState) {
            if (detailState.status == DetailSurahStatus.loading ||
                detailState.status == DetailSurahStatus.initial) {
              return const Scaffold(body: LoadingWidget());
            }
            if (detailState.status == DetailSurahStatus.error) {
              return Scaffold(
                body: AppErrorWidget(
                  message: Helpers.extractErrorMessage(
                    detailState.errorMessage ?? 'Error',
                  ),
                  onRetry: () => context.read<DetailSurahCubit>().refresh(),
                ),
              );
            }

            final surah = detailState.surah!;

            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settings) {
                return BlocBuilder<AudioCubit, AudioState>(
                  builder: (context, audioState) {
                    return Column(
                      children: [
                        AppTopBar(
                          leading: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.emeraldSubtext,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          title: surah.namaLatin,
                          subtitle:
                              '${surah.arti} · ${Formatter.displayTempatTurun(surah.tempatTurun)}',
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.auto_stories_outlined,
                                color: AppColors.emeraldSubtext,
                              ),
                              onPressed: () {
                                setState(() => _showTafsir = !_showTafsir);
                                if (_showTafsir) {
                                  context.read<TafsirCubit>().loadTafsir();
                                }
                              },
                            ),
                          ],
                        ),
                        if (!_showTafsir)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            color: AppColors.emeraldLight,
                            child: Text(
                              Formatter.surahDetailMeta(
                                namaLatin: surah.namaLatin,
                                arti: surah.arti,
                                jumlahAyat: surah.jumlahAyat,
                                juz: JuzHelper.juzForSurah(surah.nomor),
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.emeraldDark,
                              ),
                            ),
                          ),
                        if (!_showTafsir && surah.nomor != 9)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.goldLight,
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.goldMedium,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Text(
                              AppText.bismillah,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: AppTheme.arabicTextStyle(
                                fontSize: 18,
                                color: AppColors.goldDark,
                              ),
                            ),
                          ),
                        Expanded(
                          child: _showTafsir
                              ? _TafsirSection(nomor: surah.nomor)
                              : ListView.builder(
                                  padding: const EdgeInsets.only(
                                    top: AppSpacing.xs,
                                    bottom: AppSpacing.xs,
                                  ),
                                  itemCount: surah.ayat.length,
                                  itemBuilder: (context, index) {
                                    final ayat = surah.ayat[index];
                                    final playing =
                                        audioState.matches(
                                          surah.nomor,
                                          ayat.nomorAyat,
                                        ) &&
                                        audioState.isPlaying;
                                    return _DetailAyatTile(
                                      ayat: ayat,
                                      nomorSurah: surah.nomor,
                                      isHighlighted: playing,
                                      isPlaying: playing,
                                      isLoading:
                                          audioState.matches(
                                            surah.nomor,
                                            ayat.nomorAyat,
                                          ) &&
                                          audioState.isLoading,
                                      onPlay: () =>
                                          _playAyat(ayat, settings.qari),
                                      onBookmark: () => _toggleBookmark(ayat),
                                    );
                                  },
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
    );
  }

  Future<void> _playAyat(Ayat ayat, String qari) async {
    final error = await context.read<AudioCubit>().toggleAyat(ayat, qari);
    if (!mounted || error == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  Future<void> _toggleBookmark(Ayat ayat) async {
    try {
      final added = await context.read<BookmarkCubit>().toggleBookmark(ayat);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            added ? AppText.bookmarkAdded : AppText.bookmarkRemoved,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }
}

class _DetailAyatTile extends StatelessWidget {
  const _DetailAyatTile({
    required this.ayat,
    required this.nomorSurah,
    required this.isHighlighted,
    required this.isPlaying,
    required this.isLoading,
    required this.onPlay,
    required this.onBookmark,
  });

  final Ayat ayat;
  final int nomorSurah;
  final bool isHighlighted;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPlay;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, bookmarkState) {
        final isBookmarked = bookmarkState.isBookmarked(
          nomorSurah,
          ayat.nomorAyat,
        );

        return AyatCard(
          nomorAyat: ayat.nomorAyat,
          teksArab: ayat.teksArab,
          teksIndonesia: ayat.teksIndonesia,
          isHighlighted: isHighlighted,
          isPlaying: isPlaying,
          isLoading: isLoading,
          onPlay: onPlay,
          isBookmarked: isBookmarked,
          onBookmark: onBookmark,
        );
      },
    );
  }
}

class _TafsirSection extends StatelessWidget {
  const _TafsirSection({required this.nomor});

  final int nomor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TafsirCubit, TafsirState>(
      builder: (context, tafsirState) {
        if (tafsirState.status == TafsirStatus.loading ||
            tafsirState.status == TafsirStatus.initial) {
          return const LoadingWidget();
        }
        if (tafsirState.status == TafsirStatus.error) {
          return AppErrorWidget(
            message: Helpers.extractErrorMessage(
              tafsirState.errorMessage ?? 'Error',
            ),
            onRetry: () => context.read<TafsirCubit>().loadTafsir(),
          );
        }

        final tafsir = tafsirState.tafsir!;

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.sm),
          itemCount: tafsir.tafsir.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.sectionTafsir,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emeraldDark,
                      ),
                    ),
                    Text(
                      AppText.tafsirSource,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              );
            }

            final item = tafsir.tafsir[index - 1];
            final plainText = HtmlUtils.toPlainText(item.teks);

            return QCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ayat ${item.ayat}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.emerald,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    plainText,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.textPrimary,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
