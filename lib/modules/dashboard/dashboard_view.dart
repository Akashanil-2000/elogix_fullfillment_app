import 'package:elogix_fullfillment_app/core/routes/app_routes.dart';
import 'package:elogix_fullfillment_app/core/widgets/app_bottom_navigation.dart';
import 'package:elogix_fullfillment_app/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isTablet = width >= 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // STATIC TOP BAR
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? width * 0.08 : 18,
                vertical: 12,
              ),
              child: _buildTopBar(context),
            ),

            // SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? width * 0.08 : 18,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(),

                    const SizedBox(height: 16),

                    _buildHeroCard(),

                    const SizedBox(height: 12),

                    _buildFeatureGrid(isTablet),
                  ],
                ),
              ),
            ),

            // STATIC BOTTOM NAVIGATION
            // STATIC BOTTOM NAVIGATION
            const AppBottomNavigation(selectedIndex: 0),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.menu, color: AppColors.textPrimary, size: 25),
        ),

        const Spacer(),

        const Spacer(),

        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: AppColors.textPrimary,
                size: 23,
              ),
            ),

            Positioned(
              right: 5,
              top: 5,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 8),

        IconButton(
          onPressed: () {
            _showProfileMenu(context);
          },
          icon: const Icon(Icons.person_outline, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  // ============================================================
  // GREETING
  // ============================================================

  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning,',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 2),

        Text(
          'User',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),

        SizedBox(height: 4),

        Text(
          "Here's your fulfillment overview",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  // ============================================================
  // HERO CARD
  // ============================================================

  Widget _buildHeroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 132,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/warehouse.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            // Dark overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.78),
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(13, 18, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fast. Accurate. Reliable.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const SizedBox(
                    width: 190,
                    child: Text(
                      'End-to-end e-commerce\nfulfillment solutions.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 27,
                      height: 27,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FEATURE GRID
  // ============================================================

  Widget _buildFeatureGrid(bool isTablet) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 7,
      mainAxisSpacing: 7,
      childAspectRatio: isTablet ? 1.6 : 1.25,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildFeatureCard(
          icon: Icons.inventory_2_outlined,
          title: 'Inventory',
          subtitle: '& Stock',
          onTap: () {
            Get.toNamed(AppRoutes.inventory);
          },
        ),

        _buildFeatureCard(
          icon: Icons.local_shipping_outlined,
          title: 'Orders',
          subtitle: '& Shipments',
          onTap: () {},
        ),

        _buildFeatureCard(
          icon: Icons.undo_outlined,
          title: 'Returns',
          subtitle: '& RMA',
          onTap: () {},
        ),

        _buildFeatureCard(
          icon: Icons.bar_chart_outlined,
          title: 'Reports',
          subtitle: '& Analytics',
          onTap: () {},
        ),
      ],
    );
  }

  // ============================================================
  // FEATURE CARD
  // ============================================================

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(17, 14, 12, 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.primary, size: 29),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    SizedBox(width: 14),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutConfirmation(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Logout',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Get.find<AuthController>().logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
