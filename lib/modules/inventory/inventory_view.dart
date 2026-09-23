import 'package:elogix_fullfillment_app/core/widgets/app_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import 'inventory_controller.dart';
import 'models/product_sku_model.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          'Inventory',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: controller.refreshProducts,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              isTablet ? width * 0.06 : 16,
              4,
              isTablet ? width * 0.06 : 16,
              20,
            ),
            children: [
              _buildSearchField(),

              const SizedBox(height: 12),

              _buildFilters(),

              const SizedBox(height: 12),

              if (controller.filteredProducts.isEmpty)
                _buildEmptyState()
              else
                ...controller.filteredProducts.map(
                  (product) => _buildProductCard(product),
                ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 2),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      onChanged: controller.searchProducts,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: 'Search SKU / Product',
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
          size: 21,
        ),
        suffixIcon: Obx(() {
          if (controller.searchText.value.isEmpty) {
            return const SizedBox.shrink();
          }

          return IconButton(
            onPressed: controller.clearSearch,
            icon: const Icon(
              Icons.close,
              color: AppColors.textSecondary,
              size: 18,
            ),
          );
        }),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.surfaceLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _buildFilters() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(label: 'All', value: InventoryFilter.all),
            _buildFilterChip(label: 'In Stock', value: InventoryFilter.inStock),
            _buildFilterChip(
              label: 'Out of Stock',
              value: InventoryFilter.outOfStock,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required InventoryFilter value,
  }) {
    final selected = controller.selectedFilter.value == value;

    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: GestureDetector(
        onTap: () => controller.changeFilter(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget _buildProductCard(ProductSkuModel product) {
    final bool hasStock = product.localQty > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Row(
        children: [
          // Product icon instead of fake image
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: 27,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'SKU: ${product.skuCode}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),

                if (product.merchantName.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    product.merchantName,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],

                const SizedBox(height: 7),

                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: hasStock ? AppColors.success : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      hasStock ? 'In Stock' : 'Out of Stock',
                      style: TextStyle(
                        color:
                            hasStock
                                ? AppColors.textSecondary
                                : AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      _formatQuantity(product.localQty),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 24,
          ),
        ],
      ),
    );
  }

  String _formatQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }

    return quantity.toString();
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.only(top: 80),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: AppColors.textSecondary,
              size: 45,
            ),
            SizedBox(height: 12),
            Text(
              'No products found',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: AppColors.error,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
