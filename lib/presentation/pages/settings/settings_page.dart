import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/detail_surah_provider.dart';
import '../../routes/app_routes.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppText.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(AppText.darkMode),
            subtitle: const Text('Aktifkan tema gelap'),
            value: settings.isDarkMode,
            onChanged: (v) =>
                ref.read(settingsProvider.notifier).setDarkMode(v),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String>(
              value: settings.qari,
              decoration: const InputDecoration(
                labelText: AppText.qari,
                border: OutlineInputBorder(),
              ),
              items: qariLabels.entries
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  ref.read(settingsProvider.notifier).setQari(v);
                }
              },
            ),
          ),
          const Divider(),
          if (settings.lastReadSurah != null)
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text(AppText.lastRead),
              subtitle: Text('Surah ${settings.lastReadSurah}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => AppRoutes.goToDetailSurah(
                context,
                settings.lastReadSurah!,
              ),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(AppText.about),
            subtitle: const Text(AppText.aboutDesc),
          ),
        ],
      ),
    );
  }
}
