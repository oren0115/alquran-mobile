import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/doa_cubit.dart';
import '../../cubit/doa_state.dart';
import '../../models/doa.dart';
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

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<DoaCubit>().loadDoa();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoaCubit, DoaState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: ColoredBox(
            color: AppColors.background,
            child: Column(
              children: [
                AppTopBar(
                  title: AppText.doaTitle,
                  subtitle: '${state.allDoa.length} ${AppText.doaSubtitle}',
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  bottom: AppTopSearchBar(
                    hintText: AppText.searchDoaHint,
                    controller: _searchController,
                    onChanged: (value) {
                      context.read<DoaCubit>().setSearchQuery(value);
                    },
                  ),
                ),
                if (state.grups.isNotEmpty)
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
                            active: state.selectedGrup == null,
                            onTap: () =>
                                context.read<DoaCubit>().setGrup(null),
                          ),
                          ...state.grups.map(
                            (grup) => Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: QFilterTag(
                                label: _shortGrup(grup),
                                active: state.selectedGrup == grup,
                                onTap: () =>
                                    context.read<DoaCubit>().setGrup(grup),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (state.tags.isNotEmpty &&
                    (state.selectedGrup != null || state.searchQuery.isNotEmpty))
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
                        children: state.tags.take(12).map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: QFilterTag(
                              label: '#$tag',
                              active: state.selectedTag == tag,
                              onTap: () =>
                                  context.read<DoaCubit>().setTag(tag),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  String _shortGrup(String grup) {
    if (grup.length <= 22) return grup;
    return '${grup.substring(0, 20)}…';
  }

  Widget _buildBody(BuildContext context, DoaState state) {
    if (state.status == DoaStatus.loading ||
        state.status == DoaStatus.initial) {
      return const LoadingWidget();
    }

    if (state.status == DoaStatus.error) {
      return AppErrorWidget(
        message: Helpers.extractErrorMessage(
          state.errorMessage ?? AppText.errorGeneric,
        ),
        onRetry: () => context.read<DoaCubit>().refresh(),
      );
    }

    if (state.filteredList.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off_outlined,
        message: AppText.emptyDoa,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: state.filteredList.length,
      separatorBuilder: (_, index) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, index) {
        final doa = state.filteredList[index];
        return _DoaListTile(
          doa: doa,
          onTap: () => AppRoutes.goToDoaDetail(context, doa.id),
        );
      },
    );
  }
}

class _DoaListTile extends StatelessWidget {
  const _DoaListTile({
    required this.doa,
    required this.onTap,
  });

  final Doa doa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return QCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doa.nama,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            doa.grup,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
          if (doa.tags.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: doa.tags.take(3).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.emeraldLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.emeraldDark,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
