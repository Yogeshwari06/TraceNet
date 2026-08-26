import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// TraceNet App Theme Configuration
/// Implements Material 3 design system with custom branding
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light Theme for TraceNet
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryDarkBlue,
        onPrimary: AppColors.secondaryWhite,
        primaryContainer: AppColors.primaryDarkBlueLight,
        onPrimaryContainer: AppColors.primaryDarkBlue,
        secondary: AppColors.primaryDarkBlueLighter,
        onSecondary: AppColors.secondaryWhite,
        secondaryContainer: AppColors.primaryDarkBlueLight,
        onSecondaryContainer: AppColors.primaryDarkBlue,
        tertiary: AppColors.sosRed,
        onTertiary: AppColors.secondaryWhite,
        tertiaryContainer: AppColors.sosRedLight,
        onTertiaryContainer: AppColors.sosRed,
        error: AppColors.statusError,
        onError: AppColors.secondaryWhite,
        errorContainer: AppColors.sosRedLight,
        onErrorContainer: AppColors.sosRed,
        surface: AppColors.backgroundLightGrey,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.backgroundGrey,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.borderColor,
        outlineVariant: AppColors.dividerColor,
        scrim: AppColors.shadowColor,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.backgroundLightGrey,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.secondaryWhite,
        surfaceTintColor: AppColors.primaryDarkBlue,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: AppColors.secondaryWhite,
          fontSize: AppSizes.fontSizeXXLarge,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.secondaryWhite,
          size: AppSizes.iconMedium,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        surfaceTintColor: AppColors.primaryDarkBlue,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDarkBlue,
          foregroundColor: AppColors.secondaryWhite,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonPaddingHorizontal,
            vertical: AppSizes.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: AppSizes.fontSizeLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDarkBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLarge,
            vertical: AppSizes.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: AppSizes.fontSizeLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDarkBlue,
          side: const BorderSide(
            color: AppColors.primaryDarkBlue,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.buttonPaddingHorizontal,
            vertical: AppSizes.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: AppSizes.fontSizeLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.inputPadding,
          vertical: AppSizes.inputPadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.borderColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.borderColor,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.primaryDarkBlue,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.statusError,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: const BorderSide(
            color: AppColors.statusError,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: AppColors.secondaryWhiteGrey,
        hintStyle: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: AppSizes.fontSizeMedium,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppSizes.fontSizeMedium,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: const TextStyle(
          color: AppColors.statusError,
          fontSize: AppSizes.fontSizeSmall,
        ),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppSizes.fontSizeHeading1,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: AppSizes.fontSizeHeading2,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: AppSizes.fontSizeHeading3,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: AppSizes.fontSizeXXLarge,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: AppSizes.fontSizeXLarge,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: AppSizes.fontSizeLarge,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: AppSizes.fontSizeLarge,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: AppSizes.fontSizeMedium,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppSizes.fontSizeLarge,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: AppSizes.lineHeightMedium,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.fontSizeMedium,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: AppSizes.lineHeightMedium,
        ),
        bodySmall: TextStyle(
          fontSize: AppSizes.fontSizeSmall,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: AppSizes.lineHeightMedium,
        ),
        labelLarge: TextStyle(
          fontSize: AppSizes.fontSizeMedium,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: AppSizes.fontSizeSmall,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: AppSizes.fontSizeXSmall,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardWhite,
        elevation: 8.0,
        selectedItemColor: AppColors.primaryDarkBlue,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: AppSizes.fontSizeSmall,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: AppSizes.fontSizeSmall,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.sosRed,
        foregroundColor: AppColors.secondaryWhite,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardWhite,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        titleTextStyle: const TextStyle(
          fontSize: AppSizes.fontSizeXLarge,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: AppSizes.fontSizeMedium,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          color: AppColors.secondaryWhite,
          fontSize: AppSizes.fontSizeMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        elevation: 4.0,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 1.0,
        space: AppSizes.marginMedium,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppSizes.iconMedium,
      ),

      // Other Settings
      fontFamily: 'Roboto',
    );
  }

  /// Dark Theme for TraceNet (Future implementation)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Dark theme configuration can be implemented later
    );
  }
}
