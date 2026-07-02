import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final SplashController splashController = Get.find<SplashController>();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _scaleAnim = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
    splashController.nextToMoveScreen();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            // ── Decorative circles ──────────────────────────────────
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -60,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              right: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.08),
                ),
              ),
            ),

            // ── Center content ──────────────────────────────────────
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo container
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          PngAssets.commonSplashLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // App name — pak[a]so
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'pak',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Plus Jakarta Sans',
                                letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: 'a',
                              style: TextStyle(
                                color: Color(0xFFF47920),
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Plus Jakarta Sans',
                                letterSpacing: -1,
                              ),
                            ),
                            TextSpan(
                              text: 'so',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Plus Jakarta Sans',
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // CREDIT subtitle
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 28,
                            height: 1.5,
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'CREDIT',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Plus Jakarta Sans',
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 28,
                            height: 1.5,
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Tagline
                      Text(
                        'More Access. More Life.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 13,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom footer ───────────────────────────────────────
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(),
                    const SizedBox(width: 8),
                    Text('SECURE',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 10,
                          letterSpacing: 2,
                          fontFamily: 'Plus Jakarta Sans',
                        )),
                    const SizedBox(width: 8),
                    _dot(),
                    const SizedBox(width: 8),
                    Text('FAST',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 10,
                          letterSpacing: 2,
                          fontFamily: 'Plus Jakarta Sans',
                        )),
                    const SizedBox(width: 8),
                    _dot(),
                    const SizedBox(width: 8),
                    Text('RELIABLE',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 10,
                          letterSpacing: 2,
                          fontFamily: 'Plus Jakarta Sans',
                        )),
                    const SizedBox(width: 8),
                    _dot(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot() => Container(
    width: 4,
    height: 4,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: 0.3),
    ),
  );
}