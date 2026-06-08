import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Topbar hijau zamrud sesuai wireframe.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.subtitle,
    this.subtitleWidget,
    this.leading,
    this.actions,
    this.bottom,
    this.showOrnament = false,
  });

  final String? title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? bottom;
  final bool showOrnament;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.emerald,
        border: Border(
          bottom: BorderSide(color: AppColors.emeraldDark, width: 0.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        MediaQuery.paddingOf(context).top + AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: AppSpacing.xs),
              ],
              if (title != null || subtitle != null || subtitleWidget != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: const TextStyle(
                            color: AppColors.emeraldLight,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      if (subtitleWidget != null)
                        subtitleWidget!
                      else if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: AppColors.emeraldSubtext,
                            fontSize: 13,
                            decoration: TextDecoration.none,
                          ),
                        ),
                    ],
                  ),
                )
              else
                const Spacer(),
              if (actions != null) ...actions!,
            ],
          ),
          if (showOrnament) ...[
            const SizedBox(height: 4),
            const Text(
              '— ﷽ —',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.goldMedium,
                fontSize: 13,
                letterSpacing: 3,
              ),
            ),
          ],
          if (bottom != null) ...[
            const SizedBox(height: AppSpacing.xs),
            bottom!,
          ],
        ],
      ),
    );
  }
}

/// Search bar semi-transparan di dalam topbar hijau.
class AppTopSearchBar extends StatelessWidget {
  const AppTopSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.focusNode,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: const TextStyle(
          color: AppColors.emeraldLight,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.emeraldSubtext,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: AppColors.emeraldSubtext,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 36),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.15),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
