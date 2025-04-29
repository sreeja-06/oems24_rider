import 'package:get/get.dart';
import '../views/screens/splash_screen.dart';
import '../views/screens/onboarding_screen.dart';
import '../views/screens/login_screen.dart';
import '../views/screens/signup_screen.dart';
import '../views/screens/permissions_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/ride_history_screen.dart';
import '../views/screens/dashboard_screen.dart';
import '../views/screens/account_screen.dart';
import '../views/screens/drop_direction_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String permissions = '/permissions';
  static const String home = '/home';
  static const String rideHistory = '/ride-history';
  static const String dashboard = '/dashboard';
  static const String account = '/account';
  static const String dropDirection = '/drop-direction';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => SignupScreen()),
    GetPage(name: permissions, page: () => const PermissionsScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: rideHistory, page: () => const RideHistoryScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: account, page: () => const AccountScreen()),
    GetPage(name: dropDirection, page: () => DropDirectionScreen()),
  ];
}