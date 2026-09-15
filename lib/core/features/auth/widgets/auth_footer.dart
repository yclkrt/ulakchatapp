import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class AuthFooter extends ConsumerWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.h(12)),
      child: Text(
        context.ln(
          'by_continuing_yo_agree_to_the_terms_of_use_and_privacy_policy',
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: context.sp(11.5),
          color: AppColors.lightTextSecondary.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
