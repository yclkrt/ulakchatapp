import 'package:flutter/material.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class ChatsEmptyState extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  const ChatsEmptyState({
    super.key,
    required this.title,
    required this.desc,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sub = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.16),
                  AppColors.primaryLight.withValues(alpha: 0.10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.forum_rounded,
              size: 38,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, height: 1.5, color: sub),
          ),
        ],
      ),
    );
  }
}
