import 'package:elogix_fullfillment_app/modules/auth/auth_session.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import 'auth_service.dart';
import 'auth_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final isLoading = false.obs;

  final isEmailLoading = false.obs;
  final validatedEmail = ''.obs;
  final validatedName = ''.obs;

  Future<void> validateEmail(String email) async {
    final normalizedEmail = email.trim();

    if (normalizedEmail.isEmpty) {
      Get.snackbar(
        'Email',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(normalizedEmail)) {
      Get.snackbar(
        'Email',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isEmailLoading.value = true;

      final result = await _authService.validateEmail(email: normalizedEmail);

      if (result.success) {
        validatedEmail.value = normalizedEmail;
        validatedName.value = result.name ?? '';

        Get.toNamed(AppRoutes.password);
      } else {
        Get.snackbar(
          'Email Not Recognized',
          result.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Connection Error',
        'Unable to validate your email. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isEmailLoading.value = false;
    }
  }

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
          name: validatedName.value,
        );

        await AuthStorage.saveLogin(
          userId: userId,
          username: username.trim(),
          password: password,
        );

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

    Get.offAllNamed(AppRoutes.email);
  }
}
