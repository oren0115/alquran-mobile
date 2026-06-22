import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/doa_cubit.dart';
import '../../models/doa.dart';
import '../../services/helpers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../theme/app_theme.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/page_header.dart';
import '../widgets/q_card.dart';

class DoaDetailPage extends StatefulWidget {
  const DoaDetailPage({super.key, required this.doaId});

  final int doaId;

  @override
  State<DoaDetailPage> createState() => _DoaDetailPageState();
}

class _DoaDetailPageState extends State<DoaDetailPage> {
  Doa? _doa;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final doa = await context.read<DoaCubit>().getDetail(widget.doaId);
      if (!mounted) return;
      setState(() {
        _doa = doa;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_doa?.nama ?? AppText.doaTitle),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingWidget();

    if (_error != null) {
      return AppErrorWidget(
        message: Helpers.extractErrorMessage(_error!),
        onRetry: _load,
      );
    }

    final doa = _doa;
    if (doa == null) {
      return AppErrorWidget(
        message: AppText.errorGeneric,
        onRetry: _load,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        QCard(
          variant: QCardVariant.green,
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doa.nama,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.emeraldDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                doa.grup,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.emerald.withValues(alpha: 0.85),
                ),
              ),
              if (doa.tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: doa.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldLight.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.emeraldMedium.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.emeraldDark,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SectionTitle(title: AppText.doaArab),
        QCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            doa.ar,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTheme.arabicTextStyle(
              fontSize: 24,
              height: 1.8,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SectionTitle(title: AppText.doaLatin),
        QCard(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            doa.tr,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SectionTitle(title: AppText.doaTerjemahan),
        QCard(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            doa.idn,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SectionTitle(title: AppText.doaReferensi),
        QCard(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            doa.tentang,
            style: const TextStyle(
              fontSize: 13,
              height: 1.55,
              color: AppColors.muted,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppText.sumberDoa,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.muted.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
