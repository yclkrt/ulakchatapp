import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

Future<bool?> showSignOutDialog(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return showDialog<bool>(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.w(24),
          context.h(28),
          context.w(24),
          context.h(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.w(64),
              height: context.h(64),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: context.sp(28),
              ),
            ),
            SizedBox(height: context.h(16)),
            Text(
              context.ln('sign_out_title'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.sp(19),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: context.h(8)),
            Text(
              context.ln('sign_out_desc'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.sp(14),
                height: context.h(1.5),
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            SizedBox(height: context.h(20)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: context.h(13)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.r(16)),
                      ),
                    ),
                    child: Text(context.ln('cancel')),
                  ),
                ),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: context.h(13)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.r(16)),
                      ),
                    ),
                    child: Text(context.ln('confirm')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void showLanguageSheet(BuildContext context) {
  final currentLang = context.currentLocale;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) => Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(28)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(12),
        context.w(20),
        context.h(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.w(42),
            height: 5,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(context.r(99)),
            ),
          ),
          SizedBox(height: context.h(16)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              context.ln('language'),
              style: TextStyle(
                fontSize: context.sp(18),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: context.h(12)),
          LangOption(
            flag: 'TR',
            title: 'Turkce',
            subtitle: 'Turkish',
            value: 'tr',
            groupValue: currentLang,
            onTap: () {
              context.setLocale('tr');
              Navigator.of(sheetCtx).pop();
            },
          ),
          SizedBox(height: context.h(10)),
          LangOption(
            flag: 'EN',
            title: 'English',
            subtitle: 'Ingilizce',
            value: 'en',
            groupValue: currentLang,
            onTap: () {
              context.setLocale('en');
              Navigator.of(sheetCtx).pop();
            },
          ),
        ],
      ),
    ),
  );
}

void showAboutSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(28)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        context.w(24),
        context.h(12),
        context.w(24),
        context.h(32),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.w(42),
            height: context.h(5),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(context.r(99)),
            ),
          ),
          SizedBox(height: context.h(20)),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(22)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.r(22)),
              child: Image.asset(
                'assets/images/app_logo.png',
                width: context.w(100),
                height: context.h(100),
                fit: BoxFit.contain,
                errorBuilder: (_, e, s) => Icon(
                  Icons.chat_bubble_rounded,
                  color: Colors.white,
                  size: context.sp(32),
                ),
              ),
            ),
          ),
          SizedBox(height: context.h(12)),
          Text(
            context.ln('app_name'),
            style: TextStyle(
              fontSize: context.sp(20),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: context.h(4)),
          Text(
            '${context.ln('version')} ${context.ln('version_number')}',
            style: TextStyle(
              fontSize: context.sp(13),
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

class LangOption extends StatelessWidget {
  final String flag;
  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final VoidCallback onTap;
  const LangOption({
    super.key,
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.09)
          : (isDark
                ? Colors.white.withValues(alpha: 0.04)
                : AppColors.lightBackground),
      borderRadius: BorderRadius.circular(context.r(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.r(18)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(14),
            vertical: context.h(13),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.r(18)),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: context.w(1.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: context.w(44),
                height: context.h(44),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.07)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(context.r(14)),
                ),
                child: Text(
                  flag,
                  style: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: context.sp(15),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: context.sp(12),
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: context.w(24),
                height: context.h(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: selected
                      ? const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        )
                      : null,
                  border: Border.all(
                    color: selected
                        ? Colors.transparent
                        : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                    width: context.w(1.5),
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check_rounded,
                        size: context.w(15),
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
