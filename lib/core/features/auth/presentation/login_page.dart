import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_custom_bottom_sheet.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_footer.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_header.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_primary_button.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_sign_up_fields.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_social_row.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_tab_switcher.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_text_field.dart';

import '../../../router/app_router.dart';
import '../../../theme/app_colors.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  // State flags
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Simulate a brief authentic network delay for sleek feedback
      await Future.delayed(const Duration(milliseconds: 900));

      if (mounted) {
        setState(() => _isLoading = false);
        context.go(AppRoutes.main);
      }
    }
  }

  //? forgot password
  Future<void> _showForgotPasswordDialog() async {
    final email = await AuthCustomBottomSheet.show(context);
    if (email == null) return; // kullanıcı iptal etti
    if (!mounted) return;

    // Burada gerçek e-posta gönderme servisini çağırabilirsin:
    // await authService.sendResetEmail(email);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sıfırlama bağlantısı $email adresine gönderildi.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Background Ambient Gradient Blobs
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: context.w(260),
                height: context.h(260),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.22),
                      AppColors.primaryLight.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -50,
              child: Container(
                width: context.w(240),
                height: context.h(240),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.15),
                      AppColors.accentLight.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Main Content Area
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(24.0),
                    vertical: context.h(16.0),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: context.h(12)),
                            // App Logo & Header
                            AuthHeader(isSignUp: _isSignUp),
                            SizedBox(height: context.h(28)),

                            // Card with Form
                            _buildAuthCard(),

                            SizedBox(height: context.h(24)),

                            // Footer Terms
                            AuthFooter(),
                            SizedBox(height: context.h(12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(context.r(28)),
        border: Border.all(
          color: (AppColors.lightBorder).withValues(alpha: 0.9),
          width: context.w(1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.w(24)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Segmented Switcher (Giriş Yap / Kayıt Ol)
            AuthTabSwitcher(
              isSignUp: _isSignUp,
              onTapLogin: () {
                if (_isSignUp) {
                  setState(() => _isSignUp = false);
                }
              },
              onTapSignUp: () {
                if (!_isSignUp) {
                  setState(() => _isSignUp = true);
                }
              },
            ),

            SizedBox(height: context.h(24)),

            // Animated Form Fields
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _isSignUp
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: _buildSignInFields(),
              secondChild: _buildSignUpFields(_signUpFormKey),
            ),

            SizedBox(height: context.h(18)),

            // Action Button
            AuthPrimaryButton(
              isLoading: _isLoading,
              isSignUp: _isSignUp,
              handleSubmit: _handleSubmit,
            ),

            SizedBox(height: context.h(20)),

            // Divider "veya şununla devam et"
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.lightBorder)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(12)),
                  child: Text(
                    'veya',
                    style: TextStyle(
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.lightBorder)),
              ],
            ),

            SizedBox(height: context.h(18)),

            // Social Buttons & Fast Demo Access
            AuthSocialRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInFields() {
    return Column(
      children: [
        SizedBox(height: context.h(4)),
        AuthTextField(
          controller: _emailController,
          label: context.ln('e_mail'),
          hint: '',
          icon: Icons.alternate_email_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return context.ln('please_enter_your_email_address');
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
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
            if (val == null || val.isEmpty) {
              return context.ln('please_enter_your_password');
            }
            if (val.length < 6) {
              return context.ln('password_must_be_at_least_6_characters_long');
            }
            return null;
          },
        ),
        SizedBox(height: context.h(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: context.h(24),
                  width: context.w(24),
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.r(5)),
                    ),
                    onChanged: (val) {
                      setState(() => _rememberMe = val ?? false);
                    },
                  ),
                ),
                SizedBox(width: context.w(8)),
                Text(
                  context.ln('remember_me'),
                  style: TextStyle(
                    fontSize: context.sp(13),
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: _showForgotPasswordDialog,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.ln('forgot_password'),
                style: TextStyle(
                  fontSize: context.sp(13),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpFields(GlobalKey<FormState>? formKey) {
    return AuthSignUpFields(
      formKey: formKey,
      nameController: _nameController,
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      isSignUp: _isSignUp,
    );
  }
}
