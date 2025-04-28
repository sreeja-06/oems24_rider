import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes/app_routes.dart';
import 'bindings/initial_bindings.dart';
import 'services/theme_service.dart';
import 'views/screens/notifications_screen.dart';  // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //title: 'OEMS24 Captain',
      debugShowCheckedModeBanner: false,
      theme: ThemeService.lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(ThemeService.lightTheme.textTheme),
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
