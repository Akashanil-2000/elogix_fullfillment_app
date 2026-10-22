import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'inventory_service.dart';
import 'models/product_sku_model.dart';

enum InventoryFilter { inStock, outOfStock, reorder }

class InventoryController extends GetxController {
  final InventoryService _service = InventoryService();

  final products = <ProductSkuModel>[].obs;
  final filteredProducts = <ProductSkuModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final searchText = ''.obs;

  final selectedFilter = InventoryFilter.inStock.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.getProductSkus();

      products.assignAll(result);

      _applyFilters();
    } catch (e) {
      errorMessage.value = e.toString();
      filteredProducts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void searchProducts(String value) {
    searchText.value = value;
    _applyFilters();
  }

  void changeFilter(InventoryFilter filter) {
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
        products.where((product) {
          // Search
          final matchesSearch =
              search.isEmpty ||
              product.name.toLowerCase().contains(search) ||
              product.skuCode.toLowerCase().contains(search) ||
              product.merchantName.toLowerCase().contains(search);

          if (!matchesSearch) {
            return false;
          }

          // Stock filter
          switch (selectedFilter.value) {
            case InventoryFilter.inStock:
              return product.localQty > product.reorderQty;

            case InventoryFilter.outOfStock:
              return product.localQty == 0 && product.reorderQty == 0;

            case InventoryFilter.reorder:
              return product.reorderQty > product.localQty;
          }
        }).toList();

    filteredProducts.assignAll(result);
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
