import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass_liquid_navbar/glass_liquid_navbar.dart';
import 'package:icon_plus/icon_plus.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../features/chats/presentation/chats_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart'; // 👈 glassOpacityProvider için

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

    // 👈 Provider'dan saydamlık değerini oku.
    // Ayar sayfasında slider değiştiğinde bu değer otomatik güncellenir
    // ve LiquidGlassNavbar yeniden oluşturulur.
    final glassOpacity = ref.watch(glassOpacityProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseTheme = isDark
        ? LiquidGlassTheme.dark()
        : LiquidGlassTheme.light();

    final theme = baseTheme.copyWith(
      // 👈 Saydamlığı provider'dan gelen değerle override et.
      glassColor: (isDark ? Colors.white : Colors.white).withValues(
        alpha: glassOpacity,
      ),
      selectedColor: isDark ? Colors.white : AppColors.primaryDark,
      unselectedColor: isDark ? Colors.white70 : AppColors.lightTextSecondary,
      indicatorColor: isDark
          ? AppColors.primary.withValues(alpha: 0.35)
          : AppColors.primary.withValues(alpha: 0.16),
    );

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _iosIndex, children: pages),
      bottomNavigationBar: LiquidGlassNavbar(
        currentIndex: _iosIndex,
        onTap: (i) => setState(() => _iosIndex = i),
        theme: theme,
        items: [
          LiquidNavItem(
            icon: FontAwesome.comments,
            activeIcon: FontAwesome.comments_solid,
            label: context.ln('chats'),
          ),
          LiquidNavItem(
            icon: HeroIcons.cog,
            activeIcon: HeroIcons.cog,
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
            icon: const Icon(FontAwesome.comments_solid),
            inactiveIcon: const Icon(FontAwesome.comments),
            title: context.ln('chats'),
            iconSize: context.w(26),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: context.sp(12),
            ),
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        PersistentTabConfig(
          screen: const SettingsPage(),
          item: ItemConfig(
            icon: const Icon(HeroIcons.cog),
            inactiveIcon: const Icon(HeroIcons.cog),
            title: context.ln('settings'),
            iconSize: context.w(26),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: context.sp(12),
            ),
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style4BottomNavBar(
        navBarConfig: navBarConfig,
        height: context.w(76),
        navBarDecoration: NavBarDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.r(24)),
            topRight: Radius.circular(context.r(24)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
              blurRadius: context.r(20),
              offset: Offset(0, context.r(8)),
            ),
          ],
        ),
      ),
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
    );
  }
}
