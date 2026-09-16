import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class ProfileCard extends StatelessWidget {
  final String displayName;
  final String email;
  final Color cardColor;
  final VoidCallback onEditTap;
  const ProfileCard({
    super.key,
    required this.displayName,
    required this.email,
    required this.cardColor,
    required this.onEditTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sub = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(context.r(24)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 24,
            offset: Offset(context.w(0), context.h(10)),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.w(18)),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(context.w(3)),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.accentLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: context.r(30),
                  backgroundColor: isDark
                      ? AppColors.darkCard
                      : AppColors.lightBackground,
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontSize: context.sp(24),
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: context.w(16),
                  height: context.h(16),
                  decoration: BoxDecoration(
                    color: AppColors.onlineStatus,
                    shape: BoxShape.circle,
                    border: Border.all(color: cardColor, width: context.w(2.5)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: context.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: context.sp(17),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: context.h(3)),
                if (email.isNotEmpty)
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: context.sp(13),
                      color: sub,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                SizedBox(height: context.h(7)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(9),
                    vertical: context.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.onlineStatus.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: context.w(6),
                        height: context.h(6),
                        decoration: const BoxDecoration(
                          color: AppColors.onlineStatus,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: context.w(6)),
                      Text(
                        context.ln('online'),
                        style: TextStyle(
                          fontSize: context.sp(11.5),
                          fontWeight: FontWeight.w700,
                          color: AppColors.onlineStatus,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(context.r(14)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: context.r(12),
                  offset: Offset(context.w(0), context.h(4)),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(context.r(14)),
                onTap: onEditTap,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(13),
                    vertical: context.h(9),
                  ),
                  child: Text(
                    context.ln('edit'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.sp(13),
                      fontWeight: FontWeight.w700,
                    ),
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
