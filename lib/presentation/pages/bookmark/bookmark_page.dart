import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/app_topbar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/q_card.dart';
import '../../providers/ayat_audio_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../routes/app_routes.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarkListProvider);
    final qari = ref.watch(settingsProvider).qari;
    final audioState = ref.watch(ayatAudioProvider);

    final body = bookmarksAsync.when(
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
          itemCount: list.length,
          itemBuilder: (context, index) {
            final ayat = list[index];

            Future<void> playAyat() async {
              final error = await ref
                  .read(ayatAudioProvider.notifier)
                  .toggleAyat(ayat, qari);
              if (!context.mounted || error == null) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error)),
              );
            }

            final surah = ayat.nomorSurah;
            final isPlaying = surah != null &&
                audioState.matches(surah, ayat.nomorAyat) &&
                audioState.isPlaying;
            final isLoading = surah != null &&
                audioState.matches(surah, ayat.nomorAyat) &&
                audioState.isLoading;

            return QCard(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${ayat.namaSurahLatin} — Ayat ${ayat.nomorAyat}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (isPlaying || isLoading)
                        IconButton(
                          icon: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.volume_up, color: AppColors.emerald),
                          onPressed: isLoading ? null : playAyat,
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.emerald),
                        onPressed: () async {
                          final added = await ref
                              .read(bookmarkListProvider.notifier)
                              .toggleBookmark(ayat);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added
                                    ? AppText.bookmarkAdded
                                    : AppText.bookmarkRemoved,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: ayat.nomorSurah != null
                          ? () => AppRoutes.goToDetailSurah(
                                context,
                                ayat.nomorSurah!,
                              )
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              ayat.teksArab,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ayat.teksIndonesia,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (embedded) {
      return ColoredBox(
        color: AppColors.background,
        child: Column(
          children: [
            const AppTopBar(title: AppText.simpan),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppText.bookmark)),
      body: body,
    );
  }
}
