import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/features/auth/provider/auth_providers.dart';
import 'package:ulakchatapp/core/features/settings/widgets/profile_card.dart';
import 'package:ulakchatapp/core/features/settings/widgets/settings_dialogs.dart';
import 'package:ulakchatapp/core/features/settings/widgets/settings_header.dart';
import 'package:ulakchatapp/core/features/settings/widgets/settings_tiles.dart';
import 'package:ulakchatapp/core/features/settings/widgets/theme_selector.dart';
import 'package:ulakchatapp/core/providers/firebase_providers.dart';
import 'package:ulakchatapp/core/router/app_router.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';
import 'package:ulakchatapp/core/theme/theme_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});
  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Future<void> _signOut() async {
    final ok = await showSignOutDialog(context);
    if (ok == true) {
      await ref.read(authControllerProvider.notifier).signOut();
      if (!mounted) return;
      context.go(AppRoutes.login);
    }
  }

  void _soon() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(context.ln('coming_soon'))),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authStateChangesProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);
    final name = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : (user?.email?.split('@').first ?? 'UlakChat User');
    final email = user?.email ?? '';
    final lang = context.currentLocale;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final card = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final sub = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SettingsHeader(onInfoTap: () => showAboutSheet(context)),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -52),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProfileCard(
                  displayName: name,
                  email: email,
                  cardColor: card,
                  onEditTap: _soon,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionLabel(title: context.ln('appearance')),
                    SettingsGroup(
                      cardColor: card,
                      isDark: isDark,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                          child: Row(
                            children: [
                              IconBadge(
                                icon: themeMode == ThemeMode.dark
                                    ? Icons.dark_mode_rounded
                                    : themeMode == ThemeMode.light
                                    ? Icons.light_mode_rounded
                                    : Icons.settings_suggest_rounded,
                                bg: AppColors.primary.withValues(alpha: 0.12),
                                fg: AppColors.primary,
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.ln('theme'),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      themeMode == ThemeMode.system
                                          ? context.ln('theme_system')
                                          : themeMode == ThemeMode.dark
                                          ? context.ln('theme_dark')
                                          : context.ln('theme_light'),
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: sub,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkBackground
                                  : AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                ThemeChip(
                                  icon: Icons.light_mode_rounded,
                                  label: context.ln('theme_light'),
                                  selected: themeMode == ThemeMode.light,
                                  onTap: () => ref
                                      .read(themeModeProvider.notifier)
                                      .setThemeMode(ThemeMode.light),
                                ),
                                ThemeChip(
                                  icon: Icons.settings_suggest_rounded,
                                  label: context.ln('theme_system'),
                                  selected: themeMode == ThemeMode.system,
                                  onTap: () => ref
                                      .read(themeModeProvider.notifier)
                                      .setThemeMode(ThemeMode.system),
                                ),
                                ThemeChip(
                                  icon: Icons.dark_mode_rounded,
                                  label: context.ln('theme_dark'),
                                  selected: themeMode == ThemeMode.dark,
                                  onTap: () => ref
                                      .read(themeModeProvider.notifier)
                                      .setThemeMode(ThemeMode.dark),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SettingsDivider(isDark: isDark),
                        SettingsTile(
                          icon: Icons.translate_rounded,
                          iconBg: AppColors.info.withValues(alpha: 0.13),
                          iconFg: AppColors.info,
                          title: context.ln('language'),
                          subtitle: lang == 'tr' ? 'Turkce' : 'English',
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.07)
                                  : AppColors.lightBackground,
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : AppColors.lightBorder,
                              ),
                            ),
                            child: Text(
                              lang.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                color: sub,
                              ),
                            ),
                          ),
                          onTap: () => showLanguageSheet(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SectionLabel(title: context.ln('general')),
                    SettingsGroup(
                      cardColor: card,
                      isDark: isDark,
                      children: [
                        SettingsTile(
                          icon: Icons.notifications_rounded,
                          iconBg: AppColors.accent.withValues(alpha: 0.13),
                          iconFg: AppColors.accent,
                          title: context.ln('notifications'),
                          subtitle: context.ln('notifications_subtitle'),
                          onTap: _soon,
                        ),
                        SettingsDivider(isDark: isDark),
                        SettingsTile(
                          icon: Icons.lock_rounded,
                          iconBg: AppColors.success.withValues(alpha: 0.13),
                          iconFg: AppColors.success,
                          title: context.ln('privacy'),
                          subtitle: context.ln('privacy_subtitle'),
                          onTap: _soon,
                        ),
                        SettingsDivider(isDark: isDark),
                        SettingsTile(
                          icon: Icons.folder_rounded,
                          iconBg: AppColors.warning.withValues(alpha: 0.15),
                          iconFg: AppColors.warning,
                          title: context.ln('storage'),
                          subtitle: context.ln('storage_subtitle'),
                          onTap: _soon,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SectionLabel(title: context.ln('support')),
                    SettingsGroup(
                      cardColor: card,
                      isDark: isDark,
                      children: [
                        SettingsTile(
                          icon: Icons.support_agent_rounded,
                          iconBg: AppColors.primary.withValues(alpha: 0.12),
                          iconFg: AppColors.primary,
                          title: context.ln('help'),
                          subtitle: context.ln('help_subtitle'),
                          onTap: _soon,
                        ),
                        SettingsDivider(isDark: isDark),
                        SettingsTile(
                          icon: Icons.info_rounded,
                          iconBg: AppColors.primaryDark.withValues(alpha: 0.12),
                          iconFg: AppColors.primaryDark,
                          title: context.ln('about'),
                          subtitle:
                              '${context.ln('version')} ${context.ln('version_number')}',
                          onTap: () => showAboutSheet(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _signOut,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 18,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  context.ln('sign_out'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            context.ln('app_name'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: sub,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${context.ln('version')} ${context.ln('version_number')}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: sub.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
