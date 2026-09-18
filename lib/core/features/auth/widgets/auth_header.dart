import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/providers/preferences_provider.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class AuthHeader extends ConsumerWidget {
  final bool isSignUp;

  const AuthHeader({super.key, required this.isSignUp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = context.currentLocale;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_languageSwitch(currentLang, context, ref)],
        ),
        Container(
          width: context.w(84),
          height: context.h(84),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(context.w(3.0)),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkSurface,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: context.w(40),
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: context.h(16)),
        Text(
          context.ln('app_name'),
          style: TextStyle(
            fontSize: context.sp(28),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: context.h(6)),
        Text(
          isSignUp
              ? context.ln('join_us_and_start_messaging')
              : context.ln('access_your_chats_by_logging_into_your_account'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: context.sp(14),
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  AnimatedToggleSwitch<String> _languageSwitch(
    String currentLang,
    BuildContext context,
    WidgetRef ref,
  ) {
    return AnimatedToggleSwitch<String>.size(
      current: currentLang,
      values: const ['tr', 'en'],
      onChanged: (lang) {
        ref.read(appLanguageProvider.notifier).setLanguage(lang);
        context.setLocale(lang);
      },
      height: context.h(36),
      indicatorSize: const Size.fromWidth(48),
      borderWidth: 1.0,
      iconOpacity: 1.0,
      selectedIconOpacity: 1.0,
      spacing: 2.0,
      customIconBuilder: (context, local, global) => Text(
        local.value.toUpperCase(),
        style: TextStyle(
          fontSize: context.sp(12),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: Color.lerp(
            AppColors.lightTextSecondary,
            Colors.white,
            local.animationValue,
          ),
        ),
      ),
      style: ToggleStyle(
        backgroundColor: AppColors.lightBorder.withValues(alpha: 0.5),
        borderColor: AppColors.lightBorder,
        borderRadius: BorderRadius.circular(context.r(20)),
        indicatorBorderRadius: BorderRadius.circular(context.r(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      styleBuilder: (lang) => ToggleStyle(
        indicatorGradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        indicatorBoxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
