import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/audio_cubit.dart';
import '../../cubit/audio_state.dart';
import '../../cubit/bookmark_cubit.dart';
import '../../cubit/bookmark_state.dart';
import '../../cubit/settings_cubit.dart';
import '../../cubit/settings_state.dart';
import '../../services/helpers.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/page_header.dart';
import '../widgets/q_card.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final body = BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, bookmarkState) {
        if (bookmarkState.status == BookmarkStatus.loading ||
            bookmarkState.status == BookmarkStatus.initial) {
          return const LoadingWidget();
        }
        if (bookmarkState.status == BookmarkStatus.error) {
          return AppErrorWidget(
            message: Helpers.extractErrorMessage(
              bookmarkState.errorMessage ?? 'Error',
            ),
            onRetry: () => context.read<BookmarkCubit>().refresh(),
          );
        }

        final list = bookmarkState.bookmarks;
        if (list.isEmpty) {
          return const EmptyStateWidget(
            message: AppText.emptyBookmark,
            icon: Icons.bookmark_border_rounded,
          );
        }

        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settings) {
            return BlocBuilder<AudioCubit, AudioState>(
              builder: (context, audioState) {
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm,
                    0,
                    AppSpacing.sm,
                    AppSpacing.md,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final ayat = list[index];

                    Future<void> playAyat() async {
                      final error = await context
                          .read<AudioCubit>()
                          .toggleAyat(ayat, settings.qari);
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
                      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                      onTap: ayat.nomorSurah != null
                          ? () => AppRoutes.goToDetailSurah(
                                context,
                                ayat.nomorSurah!,
                              )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${ayat.namaSurahLatin} : ${ayat.nomorAyat}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isPlaying || isLoading)
                                IconButton(
                                  icon: isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.emerald,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.volume_up,
                                          color: AppColors.emerald,
                                          size: 20,
                                        ),
                                  onPressed: isLoading ? null : playAyat,
                                ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.muted,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  await context
                                      .read<BookmarkCubit>()
                                      .toggleBookmark(ayat);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(AppText.bookmarkRemoved),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            ayat.teksArab,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.arabicTextStyle(
                              fontSize: 18,
                              color: AppColors.textPrimary,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ayat.teksIndonesia,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.45,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
            const PageHeader(
              title: AppText.bookmarkTitle,
              subtitle: AppText.bookmarkSubtitle,
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppText.bookmarkTitle)),
      body: body,
    );
  }
}
