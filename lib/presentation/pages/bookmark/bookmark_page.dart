import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/ayat_card.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/section_header.dart';
import '../../providers/ayat_audio_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../routes/app_routes.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarkListProvider);
    final qari = ref.watch(settingsProvider).qari;
    final audioState = ref.watch(ayatAudioProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppText.bookmark)),
      body: bookmarksAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: Helpers.extractErrorMessage(e),
          onRetry: () => ref.read(bookmarkListProvider.notifier).refresh(),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyStateWidget(
              message: AppText.emptyBookmark,
              icon: Icons.bookmark_border_rounded,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            itemCount: list.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SectionHeader(
                  title: '${AppText.bookmark} (${list.length})',
                  topPadding: AppSpacing.sm,
                );
              }

              final ayat = list[index - 1];
              final surah = ayat.nomorSurah;
              final isPlaying = surah != null &&
                  audioState.matches(surah, ayat.nomorAyat) &&
                  audioState.isPlaying;
              final isLoading = surah != null &&
                  audioState.matches(surah, ayat.nomorAyat) &&
                  audioState.isLoading;

              Future<void> playAyat() async {
                final error = await ref
                    .read(ayatAudioProvider.notifier)
                    .toggleAyat(ayat, qari);
                if (!context.mounted || error == null) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error)),
                );
              }

              return AyatCard(
                nomorAyat: ayat.nomorAyat,
                title: '${ayat.namaSurahLatin} — Ayat ${ayat.nomorAyat}',
                teksArab: ayat.teksArab,
                teksIndonesia: ayat.teksIndonesia,
                maxArabLines: 3,
                maxIndonesiaLines: 2,
                isPlaying: isPlaying,
                isLoading: isLoading,
                onPlay: playAyat,
                onDelete: () => ref
                    .read(bookmarkListProvider.notifier)
                    .toggleBookmark(ayat),
                onTap: ayat.nomorSurah != null
                    ? () => AppRoutes.goToDetailSurah(
                          context,
                          ayat.nomorSurah!,
                        )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
