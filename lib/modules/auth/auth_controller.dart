import 'package:elogix_fullfillment_app/modules/auth/auth_session.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import 'auth_service.dart';
import 'auth_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final isLoading = false.obs;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty) {
      Get.snackbar(
        'Login',
        'Please enter your username',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'Login',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final userId = await _authService.login(
        username: username.trim(),
        password: password,
      );

      if (userId != null) {
        AuthSession.setSession(
          userId: userId,
          username: username.trim(),
          password: password,
        );

        await AuthStorage.saveLogin(userId: userId, username: username.trim());

        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        Get.snackbar(
          'Login Failed',
          'Invalid username or password',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Error',
        'Unable to connect to the server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    AuthSession.clear();

    await AuthStorage.clear();

    Get.offAllNamed(AppRoutes.login);
  }
}
