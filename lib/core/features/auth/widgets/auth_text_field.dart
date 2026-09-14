import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class AuthTextField extends ConsumerWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: context.sp(14.5),
        color: AppColors.lightTextPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          size: context.w(21),
          color: AppColors.lightTextSecondary,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.lightBackground.withValues(alpha: 0.7),
        labelStyle: TextStyle(
          fontSize: context.sp(14),
          color: AppColors.lightTextSecondary,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.r(16)),
          borderSide: BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.r(16)),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: context.w(1.8),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.r(16)),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.r(16)),
          borderSide: BorderSide(color: AppColors.error, width: context.w(1.8)),
        ),
      ),
    );
  }
}
