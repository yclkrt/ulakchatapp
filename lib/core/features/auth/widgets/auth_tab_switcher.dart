import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class AuthTabSwitcher extends ConsumerWidget {
  final bool isSignUp;
  final VoidCallback onTapLogin;
  final VoidCallback onTapSignUp;

  const AuthTabSwitcher({
    super.key,
    required this.isSignUp,
    required this.onTapLogin,
    required this.onTapSignUp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: context.h(48),
      padding: EdgeInsets.all(context.r(4)),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTapLogin,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isSignUp ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(context.r(12)),
                  boxShadow: !isSignUp
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: context.r(6),
                            offset: Offset(0, context.r(2)),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  context.ln('log_in'),
                  style: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: !isSignUp ? FontWeight.bold : FontWeight.w500,
                    color: !isSignUp
                        ? AppColors.primary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTapSignUp,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSignUp ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(context.r(12)),
                  boxShadow: isSignUp
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: context.r(6),
                            offset: Offset(0, context.r(2)),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  context.ln('sign_up'),
                  style: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: isSignUp ? FontWeight.bold : FontWeight.w500,
                    color: isSignUp
                        ? AppColors.primary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
