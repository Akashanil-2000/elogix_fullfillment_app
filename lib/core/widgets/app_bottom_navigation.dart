import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const AppBottomNavigation({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceLight, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildItem(
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
            route: AppRoutes.dashboard,
          ),

          _buildItem(
            icon: Icons.receipt_long_outlined,
            label: 'Orders',
            index: 1,
            route: null,
          ),

          _buildItem(
            icon: Icons.inventory_2_outlined,
            label: 'Inventory',
            index: 2,
            route: AppRoutes.inventory,
          ),

          _buildItem(
            icon: Icons.more_horiz,
            label: 'More',
            index: 3,
            route: null,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required int index,
    required String? route,
  }) {
    final bool selected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (route == null || selected) {
            return;
          }

          Get.offNamed(route);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 9,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
