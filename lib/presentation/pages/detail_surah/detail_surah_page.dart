import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/html_utils.dart';
import '../../../core/widgets/app_topbar.dart';
import '../../../core/widgets/ayat_card.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/q_card.dart';
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
        if (didPop) ref.read(ayatAudioProvider.notifier).stop();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: detailAsync.when(
          loading: () => const Scaffold(body: LoadingWidget()),
          error: (e, _) => Scaffold(
            body: AppErrorWidget(
              message: Helpers.extractErrorMessage(e),
              onRetry: () => ref
                  .read(detailSurahProvider(widget.nomorSurah).notifier)
                  .refresh(),
            ),
          ),
          data: (surah) {
            return Column(
              children: [
                AppTopBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.emeraldSubtext),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: surah.namaLatin,
                  subtitleWidget: _SurahSubtitle(
                    namaArab: surah.nama,
                    jumlahAyat: surah.jumlahAyat,
                  ),
                  actions: [
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: AppColors.emeraldSubtext),
                      onSelected: (value) {
                        if (value == 'tafsir') {
                          setState(() => _showTafsir = !_showTafsir);
                        } else if (value == 'murottal') {
                          AppRoutes.goToMurottal(context, surah.nomor);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'tafsir',
                          child: Text(_showTafsir ? 'Tutup Tafsir' : AppText.tafsir),
                        ),
                        const PopupMenuItem(
                          value: 'murottal',
                          child: Text(AppText.murottal),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!_showTafsir && surah.nomor != 9)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: const BoxDecoration(
                      color: AppColors.goldLight,
                      border: Border(
                        bottom: BorderSide(color: AppColors.goldMedium, width: 0.5),
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
                            final playing = audioState.matches(
                                  surah.nomor,
                                  ayat.nomorAyat,
                                ) &&
                                audioState.isPlaying;
                            return _DetailAyatTile(
                              ayat: ayat,
                              nomorSurah: surah.nomor,
                              isHighlighted: playing,
                              isPlaying: playing,
                              isLoading: audioState.matches(
                                    surah.nomor,
                                    ayat.nomorAyat,
                                  ) &&
                                  audioState.isLoading,
                              onPlay: () => _playAyat(ayat, qari),
                              onBookmark: () => _toggleBookmark(ayat),
                            );
                          },
                        ),
                ),
                if (!_showTafsir)
                  _ReadingToolbar(
                    onAudio: () => AppRoutes.goToMurottal(context, surah.nomor),
                  ),
              ],
            );
          },
        ),
      ),
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

  Future<void> _toggleBookmark(AyatEntity ayat) async {
    try {
      final added =
          await ref.read(bookmarkListProvider.notifier).toggleBookmark(ayat);
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

class _DetailAyatTile extends ConsumerWidget {
  const _DetailAyatTile({
    required this.ayat,
    required this.nomorSurah,
    required this.isHighlighted,
    required this.isPlaying,
    required this.isLoading,
    required this.onPlay,
    required this.onBookmark,
  });

  final AyatEntity ayat;
  final int nomorSurah;
  final bool isHighlighted;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPlay;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkListProvider).value ?? [];
    final isBookmarked = bookmarks.any(
      (b) => b.nomorSurah == nomorSurah && b.nomorAyat == ayat.nomorAyat,
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
  }
}

class _ReadingToolbar extends StatelessWidget {
  const _ReadingToolbar({required this.onAudio});

  final VoidCallback onAudio;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ToolbarItem(icon: Icons.text_fields, label: AppText.toolbarFont),
          _ToolbarItem(
            icon: Icons.headphones_outlined,
            label: AppText.toolbarAudio,
            onTap: onAudio,
          ),
        ],
      ),
    );
  }
}

class _ToolbarItem extends StatelessWidget {
  const _ToolbarItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.emerald),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahSubtitle extends StatelessWidget {
  const _SurahSubtitle({
    required this.namaArab,
    required this.jumlahAyat,
  });

  final String namaArab;
  final int jumlahAyat;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          color: AppColors.emeraldSubtext,
          fontSize: 13,
          decoration: TextDecoration.none,
        ),
        children: [
          TextSpan(
            text: namaArab,
            style: AppTheme.arabicTextStyle(
              fontSize: 13,
              color: AppColors.emeraldSubtext,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
          TextSpan(text: ' · $jumlahAyat ayah'),
        ],
      ),
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
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: tafsir.tafsir.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                AppText.sectionTafsir,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.emeraldDark,
                  decoration: TextDecoration.none,
                ),
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
      ),
    );
  }
}