import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class AuthSocialButton extends ConsumerWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  final VoidCallback onTap;

  const AuthSocialButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightTextPrimary,
        padding: EdgeInsets.symmetric(vertical: context.h(12)),
        side: BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(14)),
        ),
        backgroundColor: AppColors.lightBackground,
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: context.w(iconSize)),
          SizedBox(width: context.w(8)),
          Text(
            label,
            style: TextStyle(
              fontSize: context.sp(13.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
