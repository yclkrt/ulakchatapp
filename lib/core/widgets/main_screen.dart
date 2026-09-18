import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass_liquid_navbar/glass_liquid_navbar.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../features/chats/presentation/chats_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../theme/app_colors.dart';

/// Platforma duyarli ana ekran:
/// - iOS     -> Liquid Glass bottom menu
/// - Android -> persistent_bottom_nav_bar_v2
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final PersistentTabController _androidController;
  int _iosIndex = 0;

  static bool get _isIOS {
    if (kIsWeb) return false;
    // defaultTargetPlatform iOS simulator/device'da dogru calisir,
    // dart:io kullanmadan web uyumlulugu korunur.
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();
    _androidController = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _androidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isIOS) return _buildIOS(context);
    return _buildAndroid(context);
  }

  Widget _buildIOS(BuildContext context) {
    const pages = [ChatsPage(), SettingsPage()];

    // glass_liquid_navbar otomatik light/dark algilar; marka rengine
    // uydurmak icin sadece secili/indicator renklerini eziyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = isDark
        ? LiquidGlassTheme.dark().copyWith(
            selectedColor: Colors.white,
            indicatorColor: AppColors.primary.withValues(alpha: 0.35),
          )
        : LiquidGlassTheme.light().copyWith(
            selectedColor: AppColors.primaryDark,
            unselectedColor: AppColors.lightTextSecondary,
            indicatorColor: AppColors.primary.withValues(alpha: 0.16),
          );

    return Scaffold(
      // Icerik cam barin arkasinda devam etsin (paket dokumani zorunlu tutar).
      extendBody: true,
      body: IndexedStack(index: _iosIndex, children: pages),
      bottomNavigationBar: LiquidGlassNavbar(
        currentIndex: _iosIndex,
        onTap: (i) => setState(() => _iosIndex = i),
        theme: theme,
        items: [
          LiquidNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            activeIcon: Icons.chat_bubble_rounded,
            label: context.ln('chats'),
          ),
          LiquidNavItem(
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            label: context.ln('settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PersistentTabView(
      controller: _androidController,
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
