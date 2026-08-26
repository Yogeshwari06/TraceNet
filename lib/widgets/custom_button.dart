import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Custom Elevated Button Widget
/// Reusable button with consistent styling and loading state
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = width ?? double.infinity;
    final buttonHeight = height ?? AppSizes.buttonHeightMedium;

    if (isOutlined) {
      return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: OutlinedButton(
          onPressed: isEnabled && !isLoading ? onPressed : null,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon),
                      const SizedBox(width: AppSizes.paddingSmall),
                    ],
                    Text(label),
                  ],
                ),
        ),
      );
    }

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: AppColors.backgroundDarkGrey,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.secondaryWhite,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon),
                    const SizedBox(width: AppSizes.paddingSmall),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

/// SOS Emergency Button
/// Special button for emergency SOS alerts
class SOSButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const SOSButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.sosRed,
          boxShadow: [
            BoxShadow(
              color: AppColors.sosRed.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.secondaryWhite,
                  ),
                )
              : const Icon(
                  Icons.emergency,
                  color: AppColors.secondaryWhite,
                  size: 50,
                ),
        ),
      ),
    );
  }
}
