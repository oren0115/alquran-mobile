import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import 'surah_search_bar.dart';

class SurahSearchSliver extends StatelessWidget {
  const SurahSearchSliver({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SearchHeaderDelegate(
        hintText: hintText,
        onChanged: onChanged,
      ),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SearchHeaderDelegate({
    required this.hintText,
    required this.onChanged,
  });

  final String hintText;
  final ValueChanged<String> onChanged;

  static const double _height = 62;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final bg = theme.scaffoldBackgroundColor;

    return Material(
      color: bg,
      elevation: overlapsContent ? 0.5 : 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.xs,
        ),
        child: SurahSearchBar(
          hintText: hintText,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) =>
      hintText != oldDelegate.hintText;
}
