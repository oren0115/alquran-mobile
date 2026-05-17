import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../domain/entities/ayat_entity.dart';
import '../../../domain/entities/surah_entity.dart';
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
  int? _playingAyat;

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
    final qari = ref.watch(selectedQariProvider);

    return Scaffold(
      appBar: AppBar(
        title: detailAsync.maybeWhen(
          data: (d) => Text(d.namaLatin),
          orElse: () => const Text('...'),
        ),
        actions: [
          IconButton(
            icon: Icon(_showTafsir ? Icons.article : Icons.article_outlined),
            tooltip: AppText.tafsir,
            onPressed: () => setState(() => _showTafsir = !_showTafsir),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: Helpers.extractErrorMessage(e),
          onRetry: () =>
              ref.read(detailSurahProvider(widget.nomorSurah).notifier).refresh(),
        ),
        data: (surah) {
          return Column(
            children: [
              _SurahHeader(surah: surah),
              if (_showTafsir) Expanded(child: _TafsirSection(nomor: surah.nomor)),
              if (!_showTafsir)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: surah.ayat.length,
                    itemBuilder: (context, index) {
                      final ayat = surah.ayat[index];
                      return _AyatCard(
                        ayat: ayat,
                        nomorSurah: surah.nomor,
                        isPlaying: _playingAyat == ayat.nomorAyat,
                        onPlay: () => _playAyat(ayat, qari),
                        onBookmark: () => ref
                            .read(bookmarkListProvider.notifier)
                            .toggleBookmark(ayat),
                        onShare: () => _shareAyat(ayat, surah.namaLatin),
                      );
                    },
                  ),
                ),
              _SurahNavigation(
                sebelumnya: surah.suratSebelumnya,
                selanjutnya: surah.suratSelanjutnya,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _playAyat(AyatEntity ayat, String qari) async {
    final url = ayat.audio?[qari];
    if (url == null || url.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio tidak tersedia untuk qari ini')),
      );
      return;
    }

    final player = ref.read(audioPlayerProvider);
    setState(() => _playingAyat = ayat.nomorAyat);
    await player.play(UrlSource(url));
    player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playingAyat = null);
    });
  }

  void _shareAyat(AyatEntity ayat, String namaSurah) {
    final text =
        '${ayat.teksArab}\n\n${ayat.teksIndonesia}\n\n— $namaSurah : ${ayat.nomorAyat}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ayat disalin ke clipboard')),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({required this.surah});

  final DetailSurahEntity surah;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
      child: Column(
        children: [
          Text(
            surah.nama,
            style: AppTheme.arabicTextStyle(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${surah.arti} • ${surah.jumlahAyat} ayat • ${surah.tempatTurun}',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AyatCard extends ConsumerWidget {
  const _AyatCard({
    required this.ayat,
    required this.nomorSurah,
    required this.isPlaying,
    required this.onPlay,
    required this.onBookmark,
    required this.onShare,
  });

  final AyatEntity ayat;
  final int nomorSurah;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkAsync = ref.watch(
      isBookmarkedProvider((surah: nomorSurah, ayat: ayat.nomorAyat)),
    );
    final isBookmarked = bookmarkAsync.value ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  child: Text('${ayat.nomorAyat}', style: const TextStyle(fontSize: 12)),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: onPlay,
                  tooltip: 'Putar murottal',
                ),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                  ),
                  onPressed: onBookmark,
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: onShare,
                ),
              ],
            ),
            Text(
              ayat.teksArab,
              style: AppTheme.arabicTextStyle(fontSize: 26),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            Text(
              ayat.teksLatin,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              ayat.teksIndonesia,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
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
        padding: const EdgeInsets.all(16),
        itemCount: tafsir.tafsir.length,
        itemBuilder: (context, index) {
          final item = tafsir.tafsir[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ayat ${item.ayat}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(item.teks),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SurahNavigation extends StatelessWidget {
  const _SurahNavigation({
    this.sebelumnya,
    this.selanjutnya,
  });

  final SurahNavEntity? sebelumnya;
  final SurahNavEntity? selanjutnya;

  @override
  Widget build(BuildContext context) {
    final prev = sebelumnya;
    final next = selanjutnya;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            if (prev != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.detailSurah,
                    arguments: {'nomor': prev.nomor},
                  ),
                  icon: const Icon(Icons.chevron_left),
                  label: Text(prev.namaLatin, overflow: TextOverflow.ellipsis),
                ),
              ),
            if (prev != null && next != null) const SizedBox(width: 8),
            if (next != null)
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.detailSurah,
                    arguments: {'nomor': next.nomor},
                  ),
                  icon: const Icon(Icons.chevron_right),
                  label: Text(next.namaLatin, overflow: TextOverflow.ellipsis),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
