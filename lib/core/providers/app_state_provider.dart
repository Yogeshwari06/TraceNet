import 'package:flutter/foundation.dart';

/// App State Provider
/// Manages global application state using Provider pattern
class AppStateProvider extends ChangeNotifier {
  // App state variables
  bool _isOnline = true;
  bool _isInitialized = false;
  String? _userToken;
  Map<String, dynamic> _appSettings = {};

  // Getters
  bool get isOnline => _isOnline;
  bool get isInitialized => _isInitialized;
  String? get userToken => _userToken;
  Map<String, dynamic> get appSettings => _appSettings;

  /// Initialize app on startup
  Future<void> initializeApp() async {
    try {
      // Add initialization logic here
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing app: $e');
      _isInitialized = false;
      notifyListeners();
    }
  }

  /// Set online status
  void setOnlineStatus(bool isOnline) {
    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      notifyListeners();
    }
  }

  /// Set user token
  void setUserToken(String? token) {
    _userToken = token;
    notifyListeners();
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _userToken != null && _userToken!.isNotEmpty;

  /// Clear user session
  void clearUserSession() {
    _userToken = null;
    notifyListeners();
  }

  /// Update app settings
  void updateAppSettings(String key, dynamic value) {
    _appSettings[key] = value;
    notifyListeners();
  }

  /// Get app setting value
  dynamic getAppSetting(String key, {dynamic defaultValue}) {
    return _appSettings[key] ?? defaultValue;
  }

  /// Reset app state
  void reset() {
    _isOnline = true;
    _isInitialized = false;
    _userToken = null;
    _appSettings = {};
    notifyListeners();
  }
}
