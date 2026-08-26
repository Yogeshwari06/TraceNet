/// App Routes Configuration
/// Centralized routing constants for the entire application
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Root
  static const String root = '/';

  // Authentication Routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  // Main Routes
  static const String dashboard = '/dashboard';
  static const String chat = '/chat';
  static const String messages = '/messages';
  static const String messageDetails = '/message-details';
  static const String composeMessage = '/compose-message';
  static const String sos = '/sos';
  static const String communityMap = '/community-map';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String alertHistory = '/alert-history';
  static const String nearbyUsers = '/nearby-users';

  // Route names for named navigation
  static const Map<String, String> routeNames = {
    splash: 'Splash',
    login: 'Login',
    register: 'Register',
    dashboard: 'Dashboard',
    chat: 'Messages',
    messages: 'Messages',
    messageDetails: 'Message Details',
    composeMessage: 'Compose Message',
    sos: 'SOS',
    communityMap: 'Community Map',
    settings: 'Settings',
    profile: 'Profile',
    alertHistory: 'Alert History',
    nearbyUsers: 'Nearby Users',
  };
}
