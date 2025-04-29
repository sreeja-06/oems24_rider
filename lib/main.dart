import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes/app_routes.dart';
import 'bindings/initial_bindings.dart';
import 'services/theme_service.dart';
import 'views/screens/notifications_screen.dart';
import 'constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set the system UI overlay style to match our theme
  final systemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(systemOverlayStyle);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppConstants.textColor,
      displayColor: AppConstants.textColor,
    );

    return GetMaterialApp(
      title: 'OEMS24 Captain',
      debugShowCheckedModeBanner: false,
      theme: ThemeService.lightTheme.copyWith(
        textTheme: textTheme,
        colorScheme: const ColorScheme.light(
          primary: AppConstants.primaryColor,
          secondary: AppConstants.secondaryColor,
          surface: Colors.white,
          background: Colors.white,
          error: AppConstants.primaryColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppConstants.textColor,
          onBackground: AppConstants.textColor,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: [
        ...AppRoutes.routes,
        GetPage(name: '/notifications', page: () => const NotificationsScreen()),
      ],
      initialBinding: InitialBindings(),
    );
  }
}
