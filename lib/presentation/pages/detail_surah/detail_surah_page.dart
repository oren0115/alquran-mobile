import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/ayat_card.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/surah_header_banner.dart';
import '../../../core/widgets/surah_nav_bar.dart';
import '../../../domain/entities/ayat_entity.dart';
import '../../providers/ayat_audio_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/detail_surah_provider.dart';
import '../../routes/app_routes.dart';

class DetailSurahPage extends ConsumerStatefulWidget {
  const DetailSurahPage({super.key, required this.nomorSurah});

  final int nomorSurah;

  @override
  ConsumerState<DetailSurahPage> createState() => _DetailSurahPageState();
}

class _DetailSurahPageState extends ConsumerState<DetailSurahPage> {
  bool _showTafsir = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).saveLastRead(widget.nomorSurah, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(detailSurahProvider(widget.nomorSurah));
    final qari = ref.watch(settingsProvider).qari;
    final audioState = ref.watch(ayatAudioProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(ayatAudioProvider.notifier).stop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: detailAsync.maybeWhen(
            data: (d) => Text(d.namaLatin),
            orElse: () => const Text('...'),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _showTafsir ? Icons.article_rounded : Icons.article_outlined,
                size: 22,
              ),
              tooltip: AppText.tafsir,
              onPressed: () => setState(() => _showTafsir = !_showTafsir),
            ),
          ],
        ),
        body: detailAsync.when(
          loading: () => const LoadingWidget(),
          error: (e, _) => AppErrorWidget(
            message: Helpers.extractErrorMessage(e),
            onRetry: () => ref
                .read(detailSurahProvider(widget.nomorSurah).notifier)
                .refresh(),
          ),
          data: (surah) {
            return Column(
              children: [
                SurahHeaderBanner.fromDetail(surah),
                Expanded(
                  child: _showTafsir
                      ? _TafsirSection(nomor: surah.nomor)
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          itemCount: surah.ayat.length,
                          itemBuilder: (context, index) {
                            final ayat = surah.ayat[index];
                            return _DetailAyatTile(
                              ayat: ayat,
                              nomorSurah: surah.nomor,
                              namaSurahLatin: surah.namaLatin,
                              isPlaying: audioState.matches(
                                    surah.nomor,
                                    ayat.nomorAyat,
                                  ) &&
                                  audioState.isPlaying,
                              isLoading: audioState.matches(
                                    surah.nomor,
                                    ayat.nomorAyat,
                                  ) &&
                                  audioState.isLoading,
                              onPlay: () => _playAyat(ayat, qari),
                              onBookmark: () => ref
                                  .read(bookmarkListProvider.notifier)
                                  .toggleBookmark(ayat),
                              onShare: () =>
                                  _shareAyat(ayat, surah.namaLatin),
                            );
                          },
                        ),
                ),
                SurahNavBar(
                  sebelumnya: surah.suratSebelumnya,
                  selanjutnya: surah.suratSelanjutnya,
                  onPrev: surah.suratSebelumnya == null
                      ? null
                      : () => _navigateSurah(surah.suratSebelumnya!.nomor),
                  onNext: surah.suratSelanjutnya == null
                      ? null
                      : () => _navigateSurah(surah.suratSelanjutnya!.nomor),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _navigateSurah(int nomor) async {
    await ref.read(ayatAudioProvider.notifier).stop();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.detailSurah,
      arguments: {'nomor': nomor},
    );
  }

  Future<void> _playAyat(AyatEntity ayat, String qari) async {
    final error =
        await ref.read(ayatAudioProvider.notifier).toggleAyat(ayat, qari);
    if (!mounted || error == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  void _shareAyat(AyatEntity ayat, String namaSurah) {
    final text =
        '${ayat.teksArab}\n\n${ayat.teksIndonesia}\n\n— $namaSurah : ${ayat.nomorAyat}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppText.copiedToClipboard)),
    );
  }
}

class _DetailAyatTile extends ConsumerWidget {
  const _DetailAyatTile({
    required this.ayat,
    required this.nomorSurah,
    required this.namaSurahLatin,
    required this.isPlaying,
    required this.isLoading,
    required this.onPlay,
    required this.onBookmark,
    required this.onShare,
  });

  final AyatEntity ayat;
  final int nomorSurah;
  final String namaSurahLatin;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPlay;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkAsync = ref.watch(
      isBookmarkedProvider((surah: nomorSurah, ayat: ayat.nomorAyat)),
    );
    final isBookmarked = bookmarkAsync.value ?? false;

    return AyatCard(
      nomorAyat: ayat.nomorAyat,
      title: '$namaSurahLatin — Ayat ${ayat.nomorAyat}',
      teksArab: ayat.teksArab,
      teksLatin: ayat.teksLatin,
      teksIndonesia: ayat.teksIndonesia,
      isPlaying: isPlaying,
      isLoading: isLoading,
      onPlay: onPlay,
      isBookmarked: isBookmarked,
      onBookmark: onBookmark,
      onShare: onShare,
    );
  }
}

class _TafsirSection extends ConsumerWidget {
  const _TafsirSection({required this.nomor});

  final int nomor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafsirAsync = ref.watch(tafsirProvider(nomor));

    return tafsirAsync.when(
      loading: () => const LoadingWidget(),
      error: (e, _) => AppErrorWidget(
        message: Helpers.extractErrorMessage(e),
        onRetry: () => ref.invalidate(tafsirProvider(nomor)),
      ),
      data: (tafsir) => ListView.builder(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        itemCount: tafsir.tafsir.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SectionHeader(
              title: AppText.sectionTafsir,
              topPadding: AppSpacing.xs,
            );
          }
          final item = tafsir.tafsir[index - 1];
          final theme = Theme.of(context);
          final primary = theme.colorScheme.primary;

          return AppSurfaceCard(
            animatePress: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ayat ${item.ayat}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.teks,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    height: 1.5,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
