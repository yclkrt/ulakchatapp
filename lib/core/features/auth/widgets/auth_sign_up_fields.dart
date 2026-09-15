import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_text_field.dart';
import 'package:ulakchatapp/core/theme/app_colors.dart';

class AuthSignUpFields extends ConsumerStatefulWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  /// Kayıt modu aktif mi? (false ise validator'lar devre dışı kalır)
  final bool isSignUp;

  /// Alanlar arası boşluk. Varsayılan `16`.
  final double spacing;

  /// Üst boşluk. Varsayılan `4`.
  final double topSpacing;

  const AuthSignUpFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.formKey,
    this.isSignUp = true,
    this.spacing = 16,
    this.topSpacing = 4,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthSignUpFieldsState();
}

class _AuthSignUpFieldsState extends ConsumerState<AuthSignUpFields> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(height: context.h(widget.topSpacing)),

          // -------- Ad Soyad --------
          AuthTextField(
            controller: widget.nameController,
            label: context.ln('name_surname'),
            hint: '',
            icon: Icons.person_outline_rounded,
            validator: (val) {
              if (!widget.isSignUp) return null;
              if (val == null || val.trim().isEmpty) {
                return context.ln('please_enter_your_first_and_last_name');
              }
              return null;
            },
          ),
          SizedBox(height: context.h(widget.spacing)),

          // -------- E-posta --------
          AuthTextField(
            controller: widget.emailController,
            label: context.ln('email_address'),
            hint: '',
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (!widget.isSignUp) return null;
              if (val == null || val.trim().isEmpty) {
                return context.ln('please_enter_your_email_address');
              }
              if (!val.contains('@')) {
                return context.ln('enter_a_valid_email_address');
              }
              return null;
            },
          ),
          SizedBox(height: context.h(widget.spacing)),

          // -------- Şifre --------
          AuthTextField(
            controller: widget.passwordController,
            label: context.ln('password'),
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: context.w(20),
                color: AppColors.lightTextSecondary,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            validator: (val) {
              if (!widget.isSignUp) return null;
              if (val == null || val.isEmpty) {
                return context.ln('please_set_a_password');
              }
              if (val.length < 6) {
                return context.ln(
                  'the_password_must_be_at_least_6_characters_long',
                );
              }
              return null;
            },
          ),
          SizedBox(height: context.h(widget.spacing)),

          // -------- Şifre Tekrar --------
          AuthTextField(
            controller: widget.confirmPasswordController,
            label: context.ln('password_repeat'),
            hint: '••••••••',
            icon: Icons.lock_clock_outlined,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: context.w(20),
                color: AppColors.lightTextSecondary,
              ),
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
            ),
            validator: (val) {
              if (!widget.isSignUp) return null;
              if (val != widget.passwordController.text) {
                return context.ln('password_do_not_match');
              }
              return null;
            },
          ),
        ],
      ),
    );

    return form;
  }
}
