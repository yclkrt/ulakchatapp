import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../features/chats/presentation/chats_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../theme/app_colors.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PersistentTabView(
      controller: _controller,
      tabs: [
        PersistentTabConfig(
          screen: const ChatsPage(),
          item: ItemConfig(
            icon: const Icon(Icons.chat_bubble_rounded),
            inactiveIcon: const Icon(Icons.chat_bubble_outline_rounded),
            title: context.ln('chats'),
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        PersistentTabConfig(
          screen: const SettingsPage(),
          item: ItemConfig(
            icon: const Icon(Icons.settings_rounded),
            inactiveIcon: const Icon(Icons.settings_outlined),
            title: context.ln('settings'),
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style4BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
    );
  }
}
