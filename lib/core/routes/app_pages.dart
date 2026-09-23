import 'package:elogix_fullfillment_app/modules/dashboard/dashboard_controller.dart';
import 'package:elogix_fullfillment_app/modules/dashboard/dashboard_view.dart';
import 'package:elogix_fullfillment_app/modules/inventory/inventory_controller.dart';
import 'package:elogix_fullfillment_app/modules/inventory/inventory_view.dart';
import 'package:get/get.dart';

import '../../modules/login/login_view.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/splash/controllers/splash_controller.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),

    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: BindingsBuilder(() {
        Get.put(DashboardController());
      }),
    ),

    GetPage(
      name: AppRoutes.inventory,
      page: () => const InventoryView(),
      binding: BindingsBuilder(() {
        Get.put(InventoryController());
      }),
    ),
  ];
}
