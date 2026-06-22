import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/surah_cubit.dart';
import '../../cubit/surah_state.dart';
import '../../services/helpers.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/app_topbar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/q_card.dart';
import '../widgets/surah_card.dart';

class SurahListTab extends StatefulWidget {
  const SurahListTab({super.key, this.searchFocusNode});

  final FocusNode? searchFocusNode;

  @override
  State<SurahListTab> createState() => SurahListTabState();
}

class SurahListTabState extends State<SurahListTab> {
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

  void showJuzPicker() {
    context.read<SurahCubit>().setFilter(SurahFilter.juz);
    _openJuzPicker();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurahCubit, SurahState>(
      builder: (context, state) {
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
                    context.read<SurahCubit>().setSearchQuery(value);
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
                        active: state.filter == SurahFilter.all,
                        onTap: () => context
                            .read<SurahCubit>()
                            .setFilter(SurahFilter.all),
                      ),
                      const SizedBox(width: 6),
                      QFilterTag(
                        label: AppText.filterMakkiyah,
                        active: state.filter == SurahFilter.makkiyah,
                        onTap: () => context
                            .read<SurahCubit>()
                            .setFilter(SurahFilter.makkiyah),
                      ),
                      const SizedBox(width: 6),
                      QFilterTag(
                        label: AppText.filterMadaniyah,
                        active: state.filter == SurahFilter.madaniyah,
                        onTap: () => context
                            .read<SurahCubit>()
                            .setFilter(SurahFilter.madaniyah),
                      ),
                      const SizedBox(width: 6),
                      QFilterTag(
                        label: AppText.filterJuz,
                        active: state.filter == SurahFilter.juz,
                        onTap: _openJuzPicker,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: _buildList(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context, SurahState state) {
    if (state.status == SurahStatus.loading ||
        state.status == SurahStatus.initial) {
      return const LoadingWidget();
    }
    if (state.status == SurahStatus.error) {
      return AppErrorWidget(
        message: Helpers.extractErrorMessage(state.errorMessage ?? 'Error'),
        onRetry: () => context.read<SurahCubit>().refresh(),
      );
    }

    final list = state.filteredList;
    if (list.isEmpty) {
      return const EmptyStateWidget(
        message: AppText.emptySearch,
        icon: Icons.search_off_rounded,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<SurahCubit>().refresh(),
      color: AppColors.emerald,
      child: ListView.separated(
        padding: const EdgeInsets.only(
          top: AppSpacing.xs,
          bottom: AppSpacing.md,
        ),
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
            onTap: () => AppRoutes.goToDetailSurah(context, surah.nomor),
          );
        },
      ),
    );
  }

  void _openJuzPicker() {
    context.read<SurahCubit>().setFilter(SurahFilter.juz);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppText.filterJuz,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.emerald,
                        side: const BorderSide(color: AppColors.border),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('$juz'),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _filterByJuz(int juz) {
    context.read<SurahCubit>().setSearchQuery('');
    _searchController.clear();
    context.read<SurahCubit>().selectJuz(juz);
  }
}
