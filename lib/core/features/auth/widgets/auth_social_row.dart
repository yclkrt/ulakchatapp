import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_social_button.dart';
import 'package:ulakchatapp/core/router/app_router.dart';

class AuthSocialRow extends ConsumerWidget {
  const AuthSocialRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AuthSocialButton(
                icon: Icons.g_mobiledata_rounded,
                iconSize: context.w(25),
                label: 'Google',
                onTap: () => context.go(AppRoutes.main),
              ),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: AuthSocialButton(
                icon: Icons.apple_rounded,
                iconSize: context.w(25),
                label: 'Apple',
                onTap: () => context.go(AppRoutes.main),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
