import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'modules/auth/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController());

  runApp(const ElogixApp());
}

class ElogixApp extends StatelessWidget {
  const ElogixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Elogix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
