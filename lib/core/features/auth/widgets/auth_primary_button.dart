import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';
import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';

class AuthPrimaryButton extends ConsumerWidget {
  final bool isLoading;
  final bool isSignUp;
  final Future<void> Function() handleSubmit;

  const AuthPrimaryButton({
    super.key,
    required this.isLoading,
    required this.isSignUp,
    required this.handleSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: context.h(52),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(16)),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.r(16)),
          onTap: isLoading ? null : handleSubmit,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: context.w(24),
                    height: context.h(24),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isSignUp
                            ? context.ln('create_account')
                            : context.ln('log_in'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.sp(16),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: context.sp(20),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
