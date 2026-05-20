import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class SurahSearchBar extends StatefulWidget {
  const SurahSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  State<SurahSearchBar> createState() => _SurahSearchBarState();
}

class _SurahSearchBarState extends State<SurahSearchBar> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final fillColor = isDark
        ? AppColors.darkSurface.withValues(alpha: 0.85)
        : AppColors.surface;
    final borderColor = _focused
        ? primary.withValues(alpha: 0.55)
        : (isDark
            ? Colors.white.withValues(alpha: 0.06)
            : AppColors.divider);

    return SizedBox(
      height: 46,
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)
                .withValues(alpha: 0.65),
            fontSize: 14,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: _focused
                ? primary
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            borderSide: BorderSide(color: primary.withValues(alpha: 0.7), width: 1.5),
          ),
        ),
      ),
    );
  }
}
