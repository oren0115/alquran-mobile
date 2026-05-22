import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text.dart';
import '../../../domain/entities/surah_entity.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/surah_card.dart';
import '../../../core/widgets/surah_search_sliver.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/surah_provider.dart';
import '../../routes/app_routes.dart';
import '../bookmark/bookmark_page.dart';
import '../settings/settings_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _SurahListTab(),
          BookmarkPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _currentIndex,
        onSelected: (index) => setState(() => _currentIndex = index),
        items: const [
          AppBottomNavItem(
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book,
            label: AppText.home,
          ),
          AppBottomNavItem(
            icon: Icons.bookmark_outline,
            activeIcon: Icons.bookmark,
            label: AppText.bookmark,
          ),
          AppBottomNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings,
            label: AppText.settings,
          ),
        ],
      ),
    );
  }
}

class _SurahListTab extends ConsumerWidget {
  const _SurahListTab();

  SurahEntity? _findSurah(List<SurahEntity> list, int nomor) {
    for (final s in list) {
      if (s.nomor == nomor) return s;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahAsync = ref.watch(filteredSurahProvider);
    final settings = ref.watch(settingsProvider);
    final query = ref.watch(searchQueryProvider).trim();
    final showSections = query.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text(AppText.appName)),
      body: surahAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: Helpers.extractErrorMessage(e),
          onRetry: () => ref.read(surahListProvider.notifier).refresh(),
        ),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyStateWidget(
              message: AppText.emptySearch,
              icon: Icons.search_off_rounded,
            );
          }

          final lastReadNomor = settings.lastReadSurah;
          final lastReadSurah = lastReadNomor != null
              ? _findSurah(list, lastReadNomor)
              : null;
          final showLastRead =
              showSections && lastReadSurah != null && lastReadNomor != null;

          return RefreshIndicator(
            onRefresh: () => ref.read(surahListProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                if (showLastRead) ...[
                  const SliverToBoxAdapter(
                    child: SectionHeader(
                      title: AppText.lastRead,
                      topPadding: AppSpacing.sm,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SurahCard(
                      surah: lastReadSurah,
                      compact: true,
                      onTap: () => AppRoutes.goToDetailSurah(
                        context,
                        lastReadNomor,
                      ),
                    ),
                  ),
                ],
                SurahSearchSliver(
                  hintText: AppText.searchHint,
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).setQuery(value);
                  },
                ),
                if (showSections)
                  const SliverToBoxAdapter(
                    child: SectionHeader(title: AppText.allSurah),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final surah = list[index];
                      if (showLastRead && surah.nomor == lastReadNomor) {
                        return const SizedBox.shrink();
                      }
                      return SurahCard(
                        surah: surah,
                        onTap: () =>
                            AppRoutes.goToDetailSurah(context, surah.nomor),
                      );
                    },
                    childCount: list.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.md),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
