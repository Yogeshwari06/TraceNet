import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Config
import 'config/app_theme.dart';

// Constants
import 'constants/app_strings.dart';

// Routes
import 'routes/app_routes.dart';

// Screens
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/sos/sos_screen.dart';
import 'screens/map/community_map_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/alert_history/alert_history_screen.dart';
import 'screens/nearby_users/nearby_users_screen.dart';

// Providers
import 'core/providers/app_state_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/message_provider.dart';
import 'screens/messages/messages_screen.dart';
import 'screens/messages/message_details_screen.dart';
import 'screens/messages/compose_message_screen.dart';
import 'models/message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (error) {
    debugPrint('Firebase initialization skipped: $error');
  }

  runApp(const TraceNetApp());
}

class TraceNetApp extends StatefulWidget {
  const TraceNetApp({Key? key}) : super(key: key);

  @override
  State<TraceNetApp> createState() => _TraceNetAppState();
}

class _TraceNetAppState extends State<TraceNetApp> {
  late AppStateProvider _appStateProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _appStateProvider = AppStateProvider();
    _authProvider = AuthProvider();
    _authProvider.initialize();
    _initializeApp();
  }

  void _initializeApp() async {
    await _appStateProvider.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _appStateProvider),
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider()..initialize(),
        ),
        ChangeNotifierProvider<MessageProvider>(
          create: (_) => MessageProvider()..startListening(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        
        home: const SplashScreen(),
        
        // Named Routes
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.register: (context) => const RegisterScreen(),
          AppRoutes.dashboard: (context) => const DashboardScreen(),
          AppRoutes.chat: (context) => const MessagesScreen(),
          AppRoutes.messages: (context) => const MessagesScreen(),
          AppRoutes.composeMessage: (context) => const ComposeMessageScreen(),
          AppRoutes.messageDetails: (context) {
            final message = ModalRoute.of(context)?.settings.arguments as Message?;
            if (message == null) {
              return const Scaffold(
                body: Center(child: Text('Message not found')),
              );
            }
            return MessageDetailsScreen(message: message);
          },
          AppRoutes.sos: (context) => const SosScreen(),
          AppRoutes.communityMap: (context) => const CommunityMapScreen(),
          AppRoutes.settings: (context) => const SettingsScreen(),
          AppRoutes.profile: (context) => const ProfileScreen(),
          AppRoutes.alertHistory: (context) => const AlertHistoryScreen(),
          AppRoutes.nearbyUsers: (context) => const NearbyUsersScreen(),
        },
        
        // Route Generation for unknown routes
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Route not found'),
              ),
            ),
          );
        },
      ),
    );
  }
}
