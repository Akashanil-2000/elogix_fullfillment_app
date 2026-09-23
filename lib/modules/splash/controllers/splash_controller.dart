import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../auth/auth_storage.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = await AuthStorage.isLoggedIn();

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
