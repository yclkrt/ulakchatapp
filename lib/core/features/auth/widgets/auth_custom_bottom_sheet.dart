import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class AuthCustomBottomSheet extends ConsumerStatefulWidget {
  const AuthCustomBottomSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AuthCustomBottomSheet(),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthCustomBottomSheetState();
}

class _AuthCustomBottomSheetState extends ConsumerState<AuthCustomBottomSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: context.w(24),
        left: context.w(24),
        right: context.w(24),
        bottom: bottomInset + context.w(28),
      ),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(28)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: context.w(44),
                height: context.h(4),
                margin: EdgeInsets.only(bottom: context.w(20)),
                decoration: BoxDecoration(
                  color: AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(context.r(2)),
                ),
              ),
            ),

            // Başlık + açıklama
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.w(10)),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.primary,
                    size: context.w(26),
                  ),
                ),
                SizedBox(width: context.w(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.ln('forgot_your_password'),
                        style: TextStyle(
                          fontSize: context.sp(18),
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.ln(
                          'enter_your_email_address_for_the_reset_link',
                        ),
                        style: TextStyle(
                          fontSize: context.sp(13),
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(24)),

            // E-posta alanı
            TextFormField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                final v = value?.trim() ?? '';
                if (v.isEmpty) return context.ln('email_address_required');
                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegex.hasMatch(v)) {
                  return context.ln('enter_a_valid_email_address');
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: context.ln('email_address'),
                hintText: context.ln('example_gmail'),
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: AppColors.lightBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(16)),
                  borderSide: BorderSide(color: AppColors.lightBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(16)),
                  borderSide: BorderSide(color: AppColors.lightBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(16)),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: context.w(1.6),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.h(20)),

            // Gönder butonu
            SizedBox(
              width: double.infinity,
              height: context.h(52),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.r(16)),
                  ),
                ),
                onPressed: _submit,
                child: Text(
                  context.ln('send_reset_link'),
                  style: TextStyle(
                    fontSize: context.sp(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
