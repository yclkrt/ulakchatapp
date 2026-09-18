import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icon_plus/icon_plus.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../features/chats/presentation/chats_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart'; // 👈 glassOpacityProvider için

/// Platforma duyarlı ana ekran:
/// - iOS     -> adaptive_platform_ui tabanlı Liquid Glass bottom menü
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
    // Ayar sayfasında slider değiştiğinde bu değer otomatik güncellenir.
    final glassOpacity = ref.watch(glassOpacityProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _iosIndex, children: pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.w(20),
            0,
            context.w(20),
            context.h(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(36)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                  blurRadius: context.r(24),
                  offset: Offset(0, context.r(8)),
                ),
              ],
            ),
            child: AdaptiveBlurView(
              blurStyle: BlurStyle.systemUltraThinMaterial,
              borderRadius: BorderRadius.circular(context.r(36)),
              child: Container(
                height: context.h(68),
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(8),
                  vertical: context.h(6),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(36)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Colors.white.withValues(
                              alpha: 0.06 + (glassOpacity * 0.35),
                            ),
                            Colors.white.withValues(
                              alpha: 0.02 + (glassOpacity * 0.20),
                            ),
                          ]
                        : [
                            Colors.white.withValues(
                              alpha: 0.35 + (glassOpacity),
                            ),
                            Colors.white.withValues(
                              alpha: 0.15 + (glassOpacity),
                            ),
                          ],
                  ),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(
                            alpha: 0.15 + (glassOpacity * 0.20),
                          )
                        : Colors.white.withValues(alpha: 0.70),
                    width: context.w(0.8),
                  ),
                ),
                child: Row(
                  children: [
                    _buildIOSTabItem(
                      index: 0,
                      icon: CupertinoIcons.chat_bubble_2,
                      activeIcon: CupertinoIcons.chat_bubble_2_fill,
                      label: context.ln('chats'),
                      isDark: isDark,
                    ),
                    _buildIOSTabItem(
                      index: 1,
                      icon: CupertinoIcons.gear_alt,
                      activeIcon: CupertinoIcons.gear_alt_fill,
                      label: context.ln('settings'),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIOSTabItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _iosIndex == index;
    final activeColor = AppColors.primary;
    final inactiveColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_iosIndex != index) {
            HapticFeedback.lightImpact();
            setState(() => _iosIndex = index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                      ? Colors.white.withValues(alpha: 0.10)
                      : AppColors.primary.withValues(alpha: 0.10))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(context.r(28)),
            border: isSelected
                ? Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : AppColors.primary.withValues(alpha: 0.15),
                    width: 0.5,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  size: context.w(23),
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
              SizedBox(height: context.h(3)),
              Text(
                label,
                style: TextStyle(
                  fontSize: context.sp(11.5),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
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
