import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_social_button.dart';

class AuthSocialRow extends ConsumerWidget {
  const AuthSocialRow({super.key});

  void _showComingSoon(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider ile giriş çok yakında eklenecek.')),
    );
  }

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
                onTap: () => _showComingSoon(context, 'Google'),
              ),
            ),
            SizedBox(width: context.w(12)),
            Expanded(
              child: AuthSocialButton(
                icon: Icons.apple_rounded,
                iconSize: context.w(25),
                label: 'Apple',
                onTap: () => _showComingSoon(context, 'Apple'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
