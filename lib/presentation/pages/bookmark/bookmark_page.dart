import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../providers/bookmark_provider.dart';
import '../../routes/app_routes.dart';

class BookmarkPage extends ConsumerWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarkListProvider);

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
            return const Center(child: Text(AppText.emptyBookmark));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final ayat = list[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    if (ayat.nomorSurah != null) {
                      AppRoutes.goToDetailSurah(context, ayat.nomorSurah!);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${ayat.namaSurahLatin} — Ayat ${ayat.nomorAyat}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ayat.teksArab,
                          style: AppTheme.arabicTextStyle(fontSize: 22),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ayat.teksIndonesia,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => ref
                                .read(bookmarkListProvider.notifier)
                                .toggleBookmark(ayat),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
