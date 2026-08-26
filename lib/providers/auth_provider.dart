import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

/// Authentication provider for state management using Provider.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService}) : _authService = authService ?? AuthService();

  final AuthService _authService;

  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get currentUserDisplayName {
    final displayName = _currentUser?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    final email = _currentUser?.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'TraceNet user';
  }

  void initialize() {
    _authService.authStateChanges.listen((user) {
      _currentUser = user;
      _isAuthenticated = user != null;
      _errorMessage = null;
      notifyListeners();
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? bloodGroup,
    String? medicalInfo,
    required List<String> emergencyContacts,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
        bloodGroup: bloodGroup,
        medicalInfo: medicalInfo,
        emergencyContacts: emergencyContacts,
      );
      _currentUser = _authService.currentUser;
      _isAuthenticated = _currentUser != null;
    } on FirebaseAuthException catch (error) {
      setError(_mapAuthError(error.code));
      rethrow;
    } catch (error) {
      setError('We could not complete your registration right now.');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.login(email: email, password: password);
      _currentUser = _authService.currentUser;
      _isAuthenticated = _currentUser != null;
    } on FirebaseAuthException catch (error) {
      setError(_mapAuthError(error.code));
      rethrow;
    } catch (error) {
      setError('We could not sign you in right now.');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.logout();
      _currentUser = null;
      _isAuthenticated = false;
    } catch (error) {
      setError('We could not log you out right now.');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.forgotPassword(email: email);
    } on FirebaseAuthException catch (error) {
      setError(_mapAuthError(error.code));
      rethrow;
    } catch (error) {
      setError('We could not send a password reset email right now.');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkLoginStatus() async {
    _setLoading(true);
    try {
      final isLoggedIn = await _authService.checkLoginStatus();
      _currentUser = _authService.currentUser;
      _isAuthenticated = isLoggedIn;
      _errorMessage = null;
    } catch (error) {
      setError('We could not verify your session right now.');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account was found with that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'The password you entered is incorrect.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Please check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
