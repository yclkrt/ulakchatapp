import 'package:dynamic_responsive_screen/dynamic_responsive_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_header.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_primary_button.dart';
import 'package:ulakchatapp/core/features/auth/widgets/auth_social_button.dart';
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

  // State flags
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
  void _showForgotPasswordDialog() {
    final forgotEmailController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Şifrenizi mi Unuttunuz?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sıfırlama bağlantısı için e-posta adresinizi girin.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: forgotEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-posta Adresi',
                  hintText: 'ornek@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Sıfırlama bağlantısı e-posta adresinize gönderildi.',
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Sıfırlama Bağlantısı Gönder',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                      AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.22),
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
                      AppColors.accent.withValues(alpha: isDark ? 0.25 : 0.15),
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
                            _buildAuthCard(isDark),

                            SizedBox(height: context.h(24)),

                            // Footer Terms
                            _buildFooter(isDark),
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

  Widget _buildAuthCard(bool isDark) {
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
              firstChild: _buildSignInFields(isDark),
              secondChild: _buildSignUpFields(isDark),
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
                Expanded(
                  child: Divider(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(12)),
                  child: Text(
                    'veya',
                    style: TextStyle(
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
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

  Widget _buildSignInFields(bool isDark) {
    return Column(
      children: [
        SizedBox(height: 4),
        AuthTextField(
          controller: _emailController,
          label: 'E-posta',
          hint: '',
          icon: Icons.alternate_email_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'Lütfen e-posta veya telefon girin';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          label: 'Şifre',
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Lütfen şifrenizi girin';
            }
            if (val.length < 6) {
              return 'Şifre en az 6 karakter olmalıdır';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged: (val) {
                      setState(() => _rememberMe = val ?? false);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Beni hatırla',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
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
              child: const Text(
                'Şifremi unuttum',
                style: TextStyle(
                  fontSize: 13,
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

  Widget _buildSignUpFields(bool isDark) {
    return Column(
      children: [
        SizedBox(height: 4),
        AuthTextField(
          controller: _nameController,
          label: 'Ad Soyad',
          hint: '',
          icon: Icons.person_outline_rounded,
          validator: (val) {
            if (_isSignUp && (val == null || val.trim().isEmpty)) {
              return 'Lütfen adınızı ve soyadınızı girin';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _emailController,
          label: 'E-posta Adresi',
          hint: '',
          icon: Icons.alternate_email_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            if (_isSignUp) {
              if (val == null || val.trim().isEmpty) {
                return 'Lütfen e-posta girin';
              }
              if (!val.contains('@')) {
                return 'Geçerli bir e-posta adresi girin';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          label: 'Şifre',
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          validator: (val) {
            if (_isSignUp) {
              if (val == null || val.isEmpty) {
                return 'Lütfen şifre belirleyin';
              }
              if (val.length < 6) {
                return 'Şifre en az 6 karakter olmalıdır';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _confirmPasswordController,
          label: 'Şifre Tekrar',
          hint: '••••••••',
          icon: Icons.lock_clock_outlined,
          obscureText: _obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            onPressed: () {
              setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              );
            },
          ),
          validator: (val) {
            if (_isSignUp) {
              if (val != _passwordController.text) {
                return 'Şifreler eşleşmiyor';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFooter(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        'Devam ederek Kullanım Şartları ve Gizlilik Politikasını kabul etmiş olursunuz.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.5,
          color:
              (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary)
                  .withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
