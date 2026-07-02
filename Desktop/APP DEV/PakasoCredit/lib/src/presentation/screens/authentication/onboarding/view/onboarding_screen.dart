import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/onboarding/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final OnboardingController controller = Get.put(OnboardingController());
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(CurvedAnimation(
            parent: _animController, curve: Curves.easeOut));

    _animController.forward();
    controller.fetchOnboarding();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            // ── Background decorations ──────────────────────────────
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              bottom: size.height * 0.28,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.08),
                ),
              ),
            ),

            // ── Main content ────────────────────────────────────────
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),

                        // Logo
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            PngAssets.commonSplashLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // App name
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'pak',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: 'a',
                                style: TextStyle(
                                  color: Color(0xFFF47920),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: 'so',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                width: 22,
                                height: 1.5,
                                color:
                                Colors.white.withValues(alpha: 0.3)),
                            const SizedBox(width: 8),
                            Text(
                              'CREDIT',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.55),
                                fontSize: 11,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                                width: 22,
                                height: 1.5,
                                color:
                                Colors.white.withValues(alpha: 0.3)),
                          ],
                        ),

                        const Spacer(flex: 1),

                        // User avatar
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.accent, width: 2.5),
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(44),
                            child: Image.asset(
                              PngAssets.profileImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A3A7A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 46,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Welcome text
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'User Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),

                        const Spacer(flex: 2),

                        // Create Account button
                        GestureDetector(
                          onTap: () => Get.toNamed(BaseRoute.signUp),
                          child: Container(
                            width: double.infinity,
                            padding:
                            const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              'Create a New Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF0D2150),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Sign In button
                        GestureDetector(
                          onTap: () => Get.toNamed(BaseRoute.signIn),
                          child: Container(
                            width: double.infinity,
                            padding:
                            const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color:
                                Colors.white.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Trust badges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _trustBadge(
                                Icons.shield_rounded, 'Verified by\nSecurity'),
                            const SizedBox(width: 16),
                            Container(
                              width: 1,
                              height: 28,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            const SizedBox(width: 16),
                            _trustBadge(Icons.lock_rounded,
                                'Bank Level\nEncryption'),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _dot(),
                            const SizedBox(width: 6),
                            _footerText('SECURE'),
                            const SizedBox(width: 6),
                            _dot(),
                            const SizedBox(width: 6),
                            _footerText('FAST'),
                            const SizedBox(width: 6),
                            _dot(),
                            const SizedBox(width: 6),
                            _footerText('RELIABLE'),
                            const SizedBox(width: 6),
                            _dot(),
                          ],
                        ),

                        const SizedBox(height: 32),
                      ],
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

  Widget _trustBadge(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 10,
            height: 1.4,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ],
    );
  }

  Widget _dot() => Container(
    width: 3,
    height: 3,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: 0.3),
    ),
  );

  Widget _footerText(String text) => Text(
    text,
    style: TextStyle(
      color: Colors.white.withValues(alpha: 0.3),
      fontSize: 9,
      letterSpacing: 1.5,
      fontFamily: 'Plus Jakarta Sans',
    ),
  );
}