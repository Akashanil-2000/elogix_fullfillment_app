import 'package:elogix_fullfillment_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_navigation.dart';
import 'order_controller.dart';
import 'models/service_order_model.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Orders & Shipments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? width * 0.08 : 16,
          ),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 12),
              _buildFilters(),
              const SizedBox(height: 12),
              Expanded(child: Obx(() => _buildContent())),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 1),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: controller.searchController,
      onChanged: controller.searchOrders,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Search order, reference or customer...',
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
          size: 20,
        ),
        suffixIcon: Obx(
          () =>
              controller.searchText.value.isNotEmpty
                  ? IconButton(
                    onPressed: controller.clearSearch,
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Obx(
      () => Row(
        children: [
          _buildFilter(label: 'Pending', filter: OrderFilter.pending),
          const SizedBox(width: 8),
          _buildFilter(label: 'Waiting', filter: OrderFilter.waiting),
          const SizedBox(width: 8),
          _buildFilter(label: 'All', filter: OrderFilter.all),
        ],
      ),
    );
  }

  Widget _buildFilter({required String label, required OrderFilter filter}) {
    final selected = controller.selectedFilter.value == filter;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeFilter(filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 38,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.surfaceLight,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (controller.isLoading.value && controller.filteredOrders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (controller.errorMessage.value.isNotEmpty &&
        controller.filteredOrders.isEmpty) {
      return _buildError();
    }

    if (controller.filteredOrders.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: controller.refreshOrders,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 2, bottom: 16),
        itemCount: controller.filteredOrders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final order = controller.filteredOrders[index];

          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(ServiceOrderModel order) {
    final isComplete = order.state.toLowerCase() == 'complete';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.tracking, arguments: order);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order reference and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.orderRef,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _buildStateBadge(order.state, isComplete),
                ],
              ),

              const SizedBox(height: 5),

              // Order name
              Text(
                order.name,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 16),

              // Customer
              _buildInfoRow(
                Icons.person_outline,
                'Customer',
                order.customerName,
              ),

              const SizedBox(height: 12),

              // Phone number
              _buildPhoneRow(order.phone),

              const SizedBox(height: 12),

              // LMD
              _buildInfoRow(
                Icons.local_shipping_outlined,
                'LMD',
                order.lmdName.isEmpty ? '-' : order.lmdName,
              ),

              const SizedBox(height: 12),

              // Delivery status
              _buildInfoRow(
                Icons.route_outlined,
                'Delivery',
                order.lmdStatusName.isEmpty ? '-' : order.lmdStatusName,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStateBadge(String state, bool isComplete) {
    final label = state.isEmpty ? 'Unknown' : state;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color:
            isComplete
                ? AppColors.success.withValues(alpha: 0.12)
                : AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isComplete ? AppColors.success : AppColors.warning,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 42,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'No orders found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Try changing your search or filter.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 42, color: AppColors.error),
          const SizedBox(height: 12),
          const Text(
            'Unable to load orders',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.loadOrders,
            style: ElevatedButton.styleFrom(minimumSize: const Size(120, 42)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneRow(String phone) {
    final hasPhone = phone.trim().isNotEmpty;

    return Row(
      children: [
        const Icon(
          Icons.phone_outlined,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        const Text(
          'Phone:',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: InkWell(
            onTap: hasPhone ? () => _openPhoneDialer(phone) : null,
            child: Text(
              hasPhone ? phone : 'Not available',
              style: TextStyle(
                color: hasPhone ? AppColors.primary : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                decoration:
                    hasPhone ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        ),
        if (hasPhone)
          GestureDetector(
            onTap: () => _openPhoneDialer(phone),
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.call_outlined,
                size: 17,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openPhoneDialer(String phone) async {
    final number = phone.trim();

    if (number.isEmpty) {
      Get.snackbar(
        'Phone number unavailable',
        'No phone number is available for this customer.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final uri = Uri(scheme: 'tel', path: number);

    try {
      final launched = await launchUrl(uri);

      if (!launched) {
        Get.snackbar(
          'Unable to open dialer',
          'No app is available to handle phone calls on this device.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Dialer error: $e');

      Get.snackbar(
        'Unable to open dialer',
        'Could not open the phone dialer on this device.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
