import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

/// Şifre sıfırlama e-postası gönderildikten sonra gösterilen modern dialog.
class PasswordResetSentDialog extends StatelessWidget {
  final String email;
  final VoidCallback? onRetry;
  const PasswordResetSentDialog({super.key, required this.email, this.onRetry});

  static Future<void> show(
    BuildContext context,
    String email, {
    VoidCallback? onRetry,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'password-reset-sent',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (ctx, _, _) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ctx.w(24)),
          child: PasswordResetSentDialog(email: email, onRetry: onRetry),
        ),
      ),
      transitionBuilder: (ctx, anim, _, child) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final surface = AppColors.lightSurface;
    final titleC = AppColors.lightTextPrimary;
    final bodyC = AppColors.lightTextSecondary;
    final border = AppColors.lightBorder;
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(context.r(28)),
          border: Border.all(color: border.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 60,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.r(28)),
          child: Stack(
            children: [
              Positioned(
                top: -70,
                left: -40,
                right: -40,
                child: Container(
                  height: context.h(150),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.0,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.22),
                        AppColors.primaryLight.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: context.h(10),
                right: context.w(10),
                child: IconButton(
                  splashRadius: 20,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Container(
                    padding: EdgeInsets.all(context.w(6)),
                    decoration: BoxDecoration(
                      color: bodyC.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: context.w(16),
                      color: bodyC,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.w(24),
                  context.h(30),
                  context.w(24),
                  context.h(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIcon(context, surface),
                    SizedBox(height: context.h(18)),
                    _buildBadge(context),
                    SizedBox(height: context.h(12)),
                    Text(
                      context.ln('reset_link_set'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.sp(22),
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: titleC,
                      ),
                    ),
                    SizedBox(height: context.h(8)),
                    Text(
                      context.ln(
                        'we_have_sent_the_link_to_the_address_below_you_can_create_your_new_password_by_clicking_the_link',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.sp(13.5),
                        height: 1.5,
                        color: bodyC,
                      ),
                    ),
                    SizedBox(height: context.h(16)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(14),
                        vertical: context.h(12),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(context.r(16)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(context.w(8)),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.alternate_email_rounded,
                              size: context.w(16),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: context.w(10)),
                          Expanded(
                            child: Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.h(14)),
                    Container(
                      padding: EdgeInsets.all(context.w(14)),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(context.r(18)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mark_as_unread_outlined,
                            color: AppColors.warning,
                            size: context.w(18),
                          ),
                          SizedBox(width: context.w(10)),
                          Expanded(
                            child: Text(
                              context.ln(
                                'if_you_dont_see_it_in_your_inbox_check_your_spam_folder_too',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.h(18)),
                    SizedBox(
                      width: double.infinity,
                      height: context.h(52),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(context.r(16)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(context.r(16)),
                            onTap: () => Navigator.of(context).pop(),
                            child: Center(
                              child: Text(
                                context.ln('ok'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRetry?.call();
                      },
                      child: Text(context.ln('try_a_different_email_address')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, Color surface) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (_, v, child) => Transform.scale(scale: v, child: child),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: context.w(112),
            height: context.w(112),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: context.w(84),
                height: context.w(84),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryLight,
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.mark_email_read_outlined,
                  color: Colors.white,
                  size: context.w(38),
                ),
              ),
            ),
          ),
          Positioned(
            right: context.w(4),
            bottom: context.w(4),
            child: Container(
              width: context.w(32),
              height: context.w(32),
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: surface, width: 3),
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: context.w(18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.r(100)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.send_rounded,
            size: context.w(12),
            color: AppColors.success,
          ),
          SizedBox(width: context.w(6)),
          Text(
            context.ln('email_sent').toUpperCase(),
            style: TextStyle(
              fontSize: context.sp(11),
              fontWeight: FontWeight.w800,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
