import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Custom Card Widget
/// Reusable card with consistent styling
class CustomCard extends StatelessWidget {
  final Widget child;
  final double? elevation;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final VoidCallback? onTap;
  final BorderSide? border;

  const CustomCard({
    Key? key,
    required this.child,
    this.elevation,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppSizes.marginMedium,
        vertical: AppSizes.marginSmall,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: elevation ?? AppSizes.cardElevation,
          color: backgroundColor ?? AppColors.cardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppSizes.radiusMedium,
            ),
            side: border ?? BorderSide.none,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSizes.paddingMedium),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Communication Type Card
/// Display communication type and status
class CommunicationTypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isActive;
  final String? status;
  final VoidCallback? onTap;

  const CommunicationTypeCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.isActive = false,
    this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      backgroundColor: isActive
          ? AppColors.primaryDarkBlueLight.withValues(alpha: 0.1)
          : AppColors.cardWhite,
      border: isActive
          ? const BorderSide(
              color: AppColors.primaryDarkBlue,
              width: 2,
            )
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: AppSizes.iconLarge,
          ),
          const SizedBox(height: AppSizes.spacingSmall),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          if (status != null) ...[
            const SizedBox(height: AppSizes.spacingXSmall),
            Text(
              status!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? AppColors.statusSuccess
                        : AppColors.textTertiary,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// User Info Card
/// Display user information
class UserInfoCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const UserInfoCard({
    Key? key,
    required this.name,
    required this.subtitle,
    this.icon,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryDarkBlueLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primaryDarkBlue,
              ),
            ),
            const SizedBox(width: AppSizes.spacingMedium),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.spacingXSmall),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
