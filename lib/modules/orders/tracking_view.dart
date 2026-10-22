import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_bottom_navigation.dart';
import 'models/service_order_model.dart';
import 'models/tracking_line_model.dart';
import 'tracking_controller.dart';

class TrackingView extends GetView<TrackingController> {
  const TrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;

    final ServiceOrderModel? order =
        arguments is ServiceOrderModel ? arguments : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tracking Details')),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.trackingLines.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.trackingLines.isEmpty) {
            return _buildErrorState();
          }

          if (controller.trackingLines.isEmpty) {
            return _buildEmptyState();
          }

          final lines = controller.trackingLines.toList();

          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            onRefresh: controller.refreshTracking,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                _buildOrderHeader(order),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tracking History',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${lines.length} events',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                ...List.generate(
                  lines.length,
                  (index) =>
                      _buildTimelineItem(lines[index], index, lines.length),
                ),
                if (controller.errorMessage.value.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildRefreshError(),
                ],
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 1),
    );
  }

  Widget _buildOrderHeader(ServiceOrderModel? order) {
    final status =
        order?.lmdStatusName.isNotEmpty == true
            ? order!.lmdStatusName
            : order?.state ?? 'Tracking';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.primary,
                  size: 25,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order?.name ?? 'Order Tracking',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      order?.orderRef.isNotEmpty == true
                          ? order!.orderRef
                          : 'Order ID: ${controller.orderId}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.radar_rounded,
                color: AppColors.primary,
                size: 25,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: AppColors.surfaceLight, height: 1),
          const SizedBox(height: 16),
          const Text(
            'CUSTOMER',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            order?.customerName.isNotEmpty == true
                ? order!.customerName
                : 'Customer not available',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text(
                'Current order status',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _statusColor(status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(TrackingLineModel line, int index, int total) {
    final isLatest = index == 0;
    final status =
        line.lmdStatusName.isNotEmpty ? line.lmdStatusName : line.remarks;
    final color = _statusColor(status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.13),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withValues(alpha: 0.6)),
                  ),
                  child: Icon(_statusIcon(status), color: color, size: 16),
                ),
                if (index != total - 1)
                  Expanded(
                    child: Container(width: 2, color: AppColors.surfaceLight),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color:
                      isLatest
                          ? AppColors.primary.withValues(alpha: 0.35)
                          : Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          status.isNotEmpty ? status : 'Status update',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isLatest)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'LATEST',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (line.remarks.isNotEmpty &&
                      line.remarks.toLowerCase() != status.toLowerCase()) ...[
                    const SizedBox(height: 7),
                    Text(
                      line.remarks,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _formatDate(line.dateUpdate),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    final value = status.toLowerCase();

    if (value.contains('deliver')) {
      return AppColors.success;
    }

    if (value.contains('transit') ||
        value.contains('facility') ||
        value.contains('arrived')) {
      return AppColors.primary;
    }

    if (value.contains('cancel') || value.contains('fail')) {
      return AppColors.error;
    }

    return AppColors.warning;
  }

  IconData _statusIcon(String status) {
    final value = status.toLowerCase();

    if (value.contains('deliver')) {
      return Icons.check_rounded;
    }

    if (value.contains('transit')) {
      return Icons.local_shipping_outlined;
    }

    if (value.contains('facility') || value.contains('arrived')) {
      return Icons.warehouse_outlined;
    }

    return Icons.radio_button_checked_rounded;
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) {
      return value.isEmpty ? 'Date unavailable' : value;
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    if (date.hour == 0 && date.minute == 0) {
      return '$day $month $year';
    }

    return '$day $month $year • $hour:$minute';
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load tracking',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: controller.loadTracking,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: controller.refreshTracking,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_searching_rounded,
                      size: 50,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No tracking updates yet',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tracking events will appear here when available.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextButton.icon(
                      onPressed: controller.loadTracking,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Refresh tracking'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshError() {
    return TextButton.icon(
      onPressed: controller.loadTracking,
      icon: const Icon(Icons.refresh_rounded),
      label: Text(controller.errorMessage.value),
    );
  }
}
