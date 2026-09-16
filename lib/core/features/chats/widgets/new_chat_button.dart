import 'package:flutter/material.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class NewChatButton extends StatelessWidget {
  final VoidCallback onPressed;
  const NewChatButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.all(17),
            child: Icon(
              Icons.add_comment_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
        ),
      ),
    );
  }
}
