import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/utils/juz_helper.dart';
import '../../../core/widgets/app_topbar.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/q_card.dart';
import '../../../domain/entities/surah_entity.dart';
import '../../../core/utils/helpers.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/surah_provider.dart';
import '../../routes/app_routes.dart';

class BerandaTab extends ConsumerWidget {
  const BerandaTab({
    super.key,
    required this.onNavigateToTab,
    required this.onFocusSearch,
  });

  final ValueChanged<int> onNavigateToTab;
  final VoidCallback onFocusSearch;

  SurahEntity? _findSurah(List<SurahEntity> list, int nomor) {
    for (final s in list) {
      if (s.nomor == nomor) return s;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final surahAsync = ref.watch(surahListProvider);

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          AppTopBar(
            title: AppText.greeting,
            subtitle: AppText.defaultUserName,
            showOrnament: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.emeraldSubtext),
                onPressed: () {},
              ),
            ],
          ),
          Expanded(
            child: surahAsync.when(
              loading: () => const LoadingWidget(),
              error: (e, _) => AppErrorWidget(
                message: Helpers.extractErrorMessage(e),
                onRetry: () => ref.read(surahListProvider.notifier).refresh(),
              ),
              data: (list) {
                final lastReadNomor = settings.lastReadSurah;
                final lastReadSurah = lastReadNomor != null
                    ? _findSurah(list, lastReadNomor)
                    : null;
                final progress = lastReadSurah != null &&
                        settings.lastReadAyat != null
                    ? settings.lastReadAyat! / lastReadSurah.jumlahAyat
                    : 0.0;

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  children: [
                    if (lastReadSurah != null && lastReadNomor != null)
                      QCard(
                        variant: QCardVariant.green,
                        onTap: () =>
                            AppRoutes.goToDetailSurah(context, lastReadNomor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppText.continueReading,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.emerald.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lastReadSurah.namaLatin,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.emeraldDark,
                              ),
                            ),
                            Text(
                              'Ayah ${settings.lastReadAyat ?? 1} · Juz ${JuzHelper.juzForSurah(lastReadNomor)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.emerald.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            QProgressBar(progress: progress),
                          ],
                        ),
                      ),
                    if (lastReadSurah != null) const SizedBox(height: AppSpacing.xs),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: AppSpacing.xs,
                      crossAxisSpacing: AppSpacing.xs,
                      childAspectRatio: 1.6,
                      children: [
                        _QuickAction(
                          icon: Icons.menu_book_outlined,
                          label: AppText.quickSurah,
                          onTap: () => onNavigateToTab(1),
                        ),
                        _QuickAction(
                          icon: Icons.headphones_outlined,
                          label: AppText.quickMurottal,
                          onTap: () => AppRoutes.goToMurottal(
                            context,
                            lastReadNomor ?? 1,
                          ),
                        ),
                        _QuickAction(
                          icon: Icons.bookmark_outline,
                          label: AppText.quickBookmark,
                          onTap: () => onNavigateToTab(2),
                        ),
                        _QuickAction(
                          icon: Icons.search,
                          label: AppText.quickSearch,
                          onTap: () {
                            onNavigateToTab(1);
                            onFocusSearch();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const QCard(
                      variant: QCardVariant.gold,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.nextPrayer,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.gold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dhuhur',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.goldDark,
                                ),
                              ),
                              QBadge(label: '12:15'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return QCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: AppColors.emerald),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
