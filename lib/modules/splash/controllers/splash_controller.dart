import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../auth/auth_session.dart';
import '../../auth/auth_storage.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2));

    final userId = await AuthStorage.getUserId();
    final username = await AuthStorage.getUsername();
    final password = await AuthStorage.getPassword();

    if (userId != null &&
        username != null &&
        password != null &&
        password.isNotEmpty) {
      AuthSession.setSession(
        userId: userId,
        username: username,
        password: password,
      );

      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.email);
    }
  }
}
