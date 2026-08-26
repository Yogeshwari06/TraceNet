import 'package:flutter/material.dart';

/// Custom AppBar Widget
/// Reusable app bar with consistent styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final Widget? leading;
  final double? elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = false,
    this.onBackPressed,
    this.leading,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      centerTitle: centerTitle,
      elevation: elevation ?? 0,
      leading: leading ??
          (Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
