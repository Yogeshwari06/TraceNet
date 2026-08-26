import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_sizes.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

/// Splash Screen
/// Initial screen shown when app starts
/// Can be used for loading and initialization logic
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: AppSizes.animationDurationLong,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) {
        return;
      }

      final authProvider = context.read<AuthProvider>();
      try {
        await authProvider.checkLoginStatus();
        if (!mounted) {
          return;
        }
        if (authProvider.isAuthenticated) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      } catch (_) {
        if (!mounted) {
          return;
        }
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDarkBlue,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.sosRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emergency,
                  color: AppColors.secondaryWhite,
                  size: 60,
                ),
              ),
              const SizedBox(height: AppSizes.spacingLarge),

              // App Name
              Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.secondaryWhite,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSizes.spacingSmall),

              // Tagline
              Text(
                AppStrings.appTagline,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.secondaryWhiteGrey,
                      fontWeight: FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacingXLarge),

              // Loading Indicator
              const CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.sosRed),
                strokeWidth: 2.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
