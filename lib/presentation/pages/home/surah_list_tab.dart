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
import '../../../core/widgets/surah_card.dart';
import '../../providers/surah_provider.dart';
import '../../routes/app_routes.dart';

class SurahListTab extends ConsumerStatefulWidget {
  const SurahListTab({super.key, this.searchFocusNode});

  final FocusNode? searchFocusNode;

  @override
  ConsumerState<SurahListTab> createState() => SurahListTabState();
}

class SurahListTabState extends ConsumerState<SurahListTab> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void focusSearch() {
    widget.searchFocusNode?.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final surahAsync = ref.watch(filteredSurahProvider);
    final filter = ref.watch(surahFilterProvider);

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          AppTopBar(
            title: AppText.appName,
            bottom: AppTopSearchBar(
              hintText: AppText.searchHint,
              controller: _searchController,
              focusNode: widget.searchFocusNode,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.sm,
              0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  QFilterTag(
                    label: AppText.filterAll,
                    active: filter == SurahFilter.all,
                    onTap: () => ref
                        .read(surahFilterProvider.notifier)
                        .state = SurahFilter.all,
                  ),
                  const SizedBox(width: 4),
                  QFilterTag(
                    label: AppText.filterJuz,
                    active: filter == SurahFilter.juz,
                    onTap: () => _showJuzPicker(context),
                  ),
                  const SizedBox(width: 4),
                  QFilterTag(
                    label: AppText.filterMakkiyah,
                    active: filter == SurahFilter.makkiyah,
                    onTap: () => ref
                        .read(surahFilterProvider.notifier)
                        .state = SurahFilter.makkiyah,
                  ),
                  const SizedBox(width: 4),
                  QFilterTag(
                    label: AppText.filterMadaniyah,
                    active: filter == SurahFilter.madaniyah,
                    onTap: () => ref
                        .read(surahFilterProvider.notifier)
                        .state = SurahFilter.madaniyah,
                  ),
                ],
              ),
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
                  return const EmptyStateWidget(
                    message: AppText.emptySearch,
                    icon: Icons.search_off_rounded,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(surahListProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    itemCount: list.length,
                    separatorBuilder: (_, index) => const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.border,
                      indent: AppSpacing.sm,
                      endIndent: AppSpacing.sm,
                    ),
                    itemBuilder: (context, index) {
                      final surah = list[index];
                      return SurahListTile(
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

  void _showJuzPicker(BuildContext context) {
    ref.read(surahFilterProvider.notifier).state = SurahFilter.juz;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.sm),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 30,
            itemBuilder: (_, index) {
              final juz = index + 1;
              return OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _filterByJuz(juz);
                },
                child: Text('Juz $juz'),
              );
            },
          ),
        );
      },
    );
  }

  void _filterByJuz(int juz) {
    ref.read(searchQueryProvider.notifier).state = '';
    _searchController.clear();
    ref.read(selectedJuzProvider.notifier).state = juz;
  }
}
