import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/service_order_model.dart';
import 'order_service.dart';

enum OrderFilter { pending, waiting, all }

class OrderController extends GetxController {
  final OrderService _service = OrderService();

  final orders = <ServiceOrderModel>[].obs;
  final filteredOrders = <ServiceOrderModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final searchText = ''.obs;
  final selectedFilter = OrderFilter.pending.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.getOrders();

      orders.assignAll(result);
      _applyFilters();
    } catch (e) {
      errorMessage.value = e.toString();
      filteredOrders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void searchOrders(String value) {
    searchText.value = value;
    _applyFilters();
  }

  void changeFilter(OrderFilter filter) {
    selectedFilter.value = filter;
    _applyFilters();
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    _applyFilters();
  }

  void _applyFilters() {
    final search = searchText.value.trim().toLowerCase();

    final result =
        orders.where((order) {
          final matchesSearch =
              search.isEmpty ||
              order.name.toLowerCase().contains(search) ||
              order.orderRef.toLowerCase().contains(search) ||
              order.customerName.toLowerCase().contains(search) ||
              order.lmdName.toLowerCase().contains(search) ||
              order.lmdStatusName.toLowerCase().contains(search);

          if (!matchesSearch) {
            return false;
          }

          switch (selectedFilter.value) {
            case OrderFilter.pending:
              return order.state.toLowerCase() == 'process';

            case OrderFilter.waiting:
              return order.state.toLowerCase() == 'waiting';

            case OrderFilter.all:
              return true;
          }
        }).toList();

    filteredOrders.assignAll(result);
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
