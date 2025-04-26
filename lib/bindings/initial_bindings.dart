import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/signup_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/account_controller.dart';
import '../controllers/dashboard_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NotificationsController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.lazyPut(() => SignupController(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => AccountController(), fenix: true);
  }
}
