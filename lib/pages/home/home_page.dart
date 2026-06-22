import 'package:flutter/material.dart';

import '../theme/app_text.dart';
import '../widgets/app_bottom_nav.dart';
import '../bookmark/bookmark_page.dart';
import '../settings/settings_page.dart';
import 'beranda_tab.dart';
import 'surah_list_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _surahListKey = GlobalKey<SurahListTabState>();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _focusSearch() {
    _surahListKey.currentState?.focusSearch();
  }

  void _showJuzPicker() {
    _surahListKey.currentState?.showJuzPicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          BerandaTab(
            onNavigateToTab: (index) => setState(() => _currentIndex = index),
            onFocusSearch: _focusSearch,
            onShowJuzPicker: _showJuzPicker,
          ),
          SurahListTab(
            key: _surahListKey,
            searchFocusNode: _searchFocusNode,
          ),
          const BookmarkPage(embedded: true),
          const SettingsPage(embedded: true),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _currentIndex,
        onSelected: (index) => setState(() => _currentIndex = index),
        items: const [
          AppBottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: AppText.beranda,
          ),
          AppBottomNavItem(
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book,
            label: AppText.surah,
          ),
          AppBottomNavItem(
            icon: Icons.bookmark_outline,
            activeIcon: Icons.bookmark,
            label: AppText.bookmark,
          ),
          AppBottomNavItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: AppText.profil,
          ),
        ],
      ),
    );
  }
}
