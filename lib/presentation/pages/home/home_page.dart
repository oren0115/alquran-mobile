import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/surah_card.dart';
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: AppText.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: AppText.bookmark,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: AppText.settings,
          ),
        ],
      ),
    );
  }
}

class _SurahListTab extends ConsumerWidget {
  const _SurahListTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahAsync = ref.watch(filteredSurahProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppText.appName)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppText.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: surahAsync.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: Helpers.extractErrorMessage(e),
                onRetry: () => ref.read(surahListProvider.notifier).refresh(),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return const Center(child: Text(AppText.emptySearch));
                }
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(surahListProvider.notifier).refresh(),
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final surah = list[index];
                      return SurahCard(
                        surah: surah,
                        onTap: () =>
                            AppRoutes.goToDetailSurah(context, surah.nomor),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
