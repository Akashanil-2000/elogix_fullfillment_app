import 'package:elogix_fullfillment_app/modules/orders/models/service_order_model.dart';
import 'package:get/get.dart';

import 'models/tracking_line_model.dart';
import 'tracking_service.dart';

class TrackingController extends GetxController {
  final TrackingService _service = TrackingService();

  final trackingLines = <TrackingLineModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  late int orderId;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is ServiceOrderModel) {
      orderId = arguments.id;
      loadTracking();
    } else if (arguments is int) {
      orderId = arguments;
      loadTracking();
    } else if (arguments is Map) {
      final id = arguments['orderId'];

      if (id is int) {
        orderId = id;
        loadTracking();
      } else {
        errorMessage.value = 'Invalid order ID.';
      }
    } else {
      errorMessage.value = 'Order information was not provided.';
    }
  }

  Future<void> loadTracking() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.getTracking(orderId);
      trackingLines.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTracking() async {
    await loadTracking();
  }
}
