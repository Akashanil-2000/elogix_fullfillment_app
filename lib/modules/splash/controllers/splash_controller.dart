import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../auth/auth_session.dart';
import '../../auth/auth_storage.dart';

class SplashController extends GetxController {
  static const Duration _minimumSplashDuration = Duration(seconds: 2);

  @override
  void onInit() {
    super.onInit();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Read stored credentials while the splash is visible instead of after it.
    final results = await Future.wait<bool>([
      _restoreSession(),
      Future<bool>.delayed(_minimumSplashDuration, () => true),
    ]);

    final hasSession = results.first;

    Get.offAllNamed(hasSession ? AppRoutes.dashboard : AppRoutes.email);
  }

  /// Restores the saved login into [AuthSession].
  ///
  /// Returns false (and clears any partial/corrupt data) if nothing usable is
  /// stored or if storage cannot be read, so the app never hangs on splash.
  Future<bool> _restoreSession() async {
    try {
      final userId = await AuthStorage.getUserId();
      final username = await AuthStorage.getUsername();
      final password = await AuthStorage.getPassword();
      final name = await AuthStorage.getName();

      if (userId == null ||
          username == null ||
          password == null ||
          password.isEmpty) {
        return false;
      }

      AuthSession.setSession(
        userId: userId,
        username: username,
        password: password,
        name: name,
      );
      return true;
    } catch (e, stackTrace) {
      debugPrint('Failed to restore session: $e\n$stackTrace');

      try {
        await AuthStorage.clear();
      } catch (_) {
        // Storage is unusable; sending the user to login is still correct.
      }
      AuthSession.clear();
      return false;
    }
  }
}
