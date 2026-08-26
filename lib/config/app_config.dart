/// Application Configuration
/// Central configuration constants
class AppConfig {
  // Private constructor
  AppConfig._();

  // API Configuration
  static const String apiBaseUrl = 'https://api.tracenet.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Firebase Configuration
  // Will be configured with google-services.json and GoogleService-Info.plist

  // Location Configuration
  static const double nearbyRadiusKm = 5.0;

  // Communication Configuration
  static const int bluetoothTimeout = 30; // seconds
  static const int wifiDirectTimeout = 60; // seconds

  // Storage Configuration
  static const String hiveBoxName = 'tracenet_storage';

  // Debug Mode
  static const bool debugMode = true;
}
