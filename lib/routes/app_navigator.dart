import 'package:flutter/material.dart';
import 'app_routes.dart';

/// App Navigator
/// Centralized navigation helper methods
class AppNavigator {
  // Private constructor to prevent instantiation
  AppNavigator._();

  /// Navigate to splash screen
  static Future<void> toSplash(BuildContext context) async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.splash,
      (route) => false,
    );
  }

  /// Navigate to login screen
  static Future<void> toLogin(BuildContext context) async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  /// Navigate to register screen
  static Future<void> toRegister(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.register);
  }

  /// Navigate to dashboard
  static Future<void> toDashboard(BuildContext context) async {
    await Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.dashboard,
      (route) => false,
    );
  }

  /// Navigate to chat
  static Future<void> toChat(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.chat);
  }

  /// Navigate to SOS
  static Future<void> toSos(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.sos);
  }

  /// Navigate to community map
  static Future<void> toCommunityMap(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.communityMap);
  }

  /// Navigate to settings
  static Future<void> toSettings(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.settings);
  }

  /// Navigate to profile
  static Future<void> toProfile(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.profile);
  }

  /// Navigate to alert history
  static Future<void> toAlertHistory(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.alertHistory);
  }

  /// Navigate to nearby users
  static Future<void> toNearbyUsers(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.nearbyUsers);
  }

  /// Go back
  static void back(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Replace current screen
  static Future<void> replace(BuildContext context, String routeName) async {
    await Navigator.of(context).pushReplacementNamed(routeName);
  }
}
