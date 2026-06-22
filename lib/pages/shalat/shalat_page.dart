import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/settings_cubit.dart';
import '../../cubit/settings_state.dart';
import '../../cubit/shalat_cubit.dart';
import '../../cubit/shalat_state.dart';
import '../../models/shalat.dart';
import '../../services/helpers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/page_header.dart';
import '../widgets/q_card.dart';

class ShalatPage extends StatefulWidget {
  const ShalatPage({super.key});

  @override
  State<ShalatPage> createState() => _ShalatPageState();
}

class _ShalatPageState extends State<ShalatPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShalatCubit>().loadJadwal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppText.jadwalShalat),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ShalatCubit>().refresh(),
          ),
        ],
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return BlocBuilder<ShalatCubit, ShalatState>(
            builder: (context, state) {
              if (state.status == ShalatStatus.loading &&
                  state.jadwal == null) {
                return const LoadingWidget();
              }

              if (state.status == ShalatStatus.error && state.jadwal == null) {
                return AppErrorWidget(
                  message: Helpers.extractErrorMessage(
                    state.errorMessage ?? AppText.errorGeneric,
                  ),
                  onRetry: () => context.read<ShalatCubit>().refresh(),
                );
              }

              final jadwal = state.jadwal;
              final today = state.today;

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.sm),
                children: [
                  QCard(
                    variant: QCardVariant.green,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.emerald,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                settings.kabkota,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.emeraldDark,
                                ),
                              ),
                              Text(
                                settings.provinsi,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.emerald.withValues(
                                    alpha: 0.85,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => _showLocationSheet(context, settings),
                          child: const Text('Ubah'),
                        ),
                      ],
                    ),
                  ),
                  if (state.nextPrayer != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _NextPrayerBanner(nextPrayer: state.nextPrayer!),
                  ],
                  if (today != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    SectionTitle(
                      title: '${AppText.jadwalHariIni} · ${today.hari}',
                    ),
                    QCard(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xs,
                      ),
                      child: Column(
                        children: today.waktuLengkap.map((item) {
                          final isMain = [
                            'Subuh',
                            'Dzuhur',
                            'Ashar',
                            'Maghrib',
                            'Isya',
                          ].contains(item.name);
                          final isNext =
                              state.nextPrayer?.name == item.name;
                          return _WaktuRow(
                            name: item.name,
                            time: item.time,
                            highlight: isNext,
                            bold: isMain,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (jadwal != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    SectionTitle(
                      title: 'Bulan ${jadwal.bulanNama} ${jadwal.tahun}',
                    ),
                    ...jadwal.jadwal.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: QCard(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.tanggal} ${jadwal.bulanNama} · ${item.hari}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: 4,
                                children: item.waktuSholat
                                    .map(
                                      (w) => Text(
                                        '${w.name} ${w.time}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.muted,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppText.sumberShalat,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.muted.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showLocationSheet(
    BuildContext context,
    SettingsState settings,
  ) async {
    final shalatCubit = context.read<ShalatCubit>();
    final settingsCubit = context.read<SettingsCubit>();

    await shalatCubit.loadProvinsi();
    if (!context.mounted) return;

    var selectedProvinsi = settings.provinsi;
    var selectedKabkota = settings.kabkota;

    await shalatCubit.loadKabkota(selectedProvinsi);
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: shalatCubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              top: AppSpacing.sm,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom +
                  AppSpacing.md,
            ),
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                return BlocBuilder<ShalatCubit, ShalatState>(
                  builder: (context, shalatState) {
                    final kabkotaList = shalatState.kabkotaList;
                    if (!kabkotaList.contains(selectedKabkota) &&
                        kabkotaList.isNotEmpty) {
                      selectedKabkota = kabkotaList.first;
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          AppText.lokasiShalat,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        DropdownButtonFormField<String>(
                          initialValue: shalatState.provinsiList
                                  .contains(selectedProvinsi)
                              ? selectedProvinsi
                              : null,
                          decoration: const InputDecoration(
                            labelText: AppText.provinsi,
                          ),
                          isExpanded: true,
                          items: shalatState.provinsiList
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p),
                                ),
                              )
                              .toList(),
                          onChanged: (value) async {
                            if (value == null) return;
                            setSheetState(() {
                              selectedProvinsi = value;
                            });
                            await shalatCubit.loadKabkota(value);
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        if (shalatState.loadingKabkota)
                          const Center(child: CircularProgressIndicator())
                        else
                          DropdownButtonFormField<String>(
                            initialValue: kabkotaList.contains(selectedKabkota)
                                ? selectedKabkota
                                : null,
                            decoration: const InputDecoration(
                              labelText: AppText.kabkota,
                            ),
                            isExpanded: true,
                            items: kabkotaList
                                .map(
                                  (k) => DropdownMenuItem(
                                    value: k,
                                    child: Text(k),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setSheetState(() => selectedKabkota = value);
                            },
                          ),
                        const SizedBox(height: AppSpacing.md),
                        FilledButton(
                          onPressed: shalatState.loadingKabkota
                              ? null
                              : () async {
                                  await settingsCubit.setLocation(
                                    selectedProvinsi,
                                    selectedKabkota,
                                  );
                                  await shalatCubit.loadJadwal();
                                  if (sheetContext.mounted) {
                                    Navigator.pop(sheetContext);
                                  }
                                },
                          child: const Text('Simpan'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _NextPrayerBanner extends StatelessWidget {
  const _NextPrayerBanner({required this.nextPrayer});

  final NextPrayer nextPrayer;

  @override
  Widget build(BuildContext context) {
    return QCard(
      variant: QCardVariant.gold,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.nextPrayer,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.goldDark.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nextPrayer.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldDark,
                  ),
                ),
                Text(
                  '± ${nextPrayer.remainingLabel}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.goldDark.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          Text(
            nextPrayer.time,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.goldDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaktuRow extends StatelessWidget {
  const _WaktuRow({
    required this.name,
    required this.time,
    this.highlight = false,
    this.bold = false,
  });

  final String name;
  final String time;
  final bool highlight;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final bg = highlight ? AppColors.goldLight : Colors.transparent;
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
                color: highlight ? AppColors.goldDark : AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: highlight ? AppColors.goldDark : AppColors.emerald,
            ),
          ),
        ],
      ),
    );
  }
}
