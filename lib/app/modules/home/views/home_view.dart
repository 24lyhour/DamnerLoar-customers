import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_hero_banner_widget.dart';
import '../widgets/hotel_search_form.dart';
import '../widgets/package_search_form.dart';
import '../widgets/popular_destinations_widget.dart';
import '../widgets/popular_hotels_widget.dart';
import '../widgets/popular_transport_widget.dart';
import '../widgets/search_tab_bar_widget.dart';
import '../widgets/transport_search_form_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const double _headerHeight = 220;
  static const double _cardOverlap = 60;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColor.surface,
        body: Stack(
          children: [
            // Hero banner background (fixed at top)
            HomeHeroBanner(height: _headerHeight + topPadding),

            // Scrollable content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header content (over the banner)
                  SizedBox(
                    height: _headerHeight + topPadding - _cardOverlap,
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          const HomeHeader(),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.screen,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(
                                () => Text(
                                  '${AppString.hiUser.tr} ${controller.userName.value},',
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.screen,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppString.whereAreYouGoing.tr,
                                style: AppTextStyle.headline.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ),
                    ),
                  ),

                  // Search card (overlaps banner)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screen,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        const SearchTabBar(),
                        Obx(
                          () => Skeletonizer(
                            enabled: controller.isTabLoading.value,
                            effect: const ShimmerEffect(),
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              alignment: Alignment.topCenter,
                              child: _buildSearchForm(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Popular destinations
                  const PopularDestinations(),
                  const SizedBox(height: AppSpacing.xl),

                  // Popular hotels
                  const PopularHotels(),
                  const SizedBox(height: AppSpacing.xl),

                  // Popular transport routes
                  const PopularTransport(),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            onTap: controller.setNavIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColor.primary,
            unselectedItemColor: AppColor.textSecondary,
            selectedLabelStyle: AppTextStyle.caption.copyWith(
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: AppTextStyle.caption,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: AppString.home.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.confirmation_number_outlined),
                activeIcon: const Icon(Icons.confirmation_number),
                label: AppString.myBookings.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_outline),
                activeIcon: const Icon(Icons.favorite),
                label: AppString.saved.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: AppString.profile.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchForm() {
    switch (controller.currentTab.value) {
      case SearchTab.transport:
        return const TransportSearchForm();
      case SearchTab.hotel:
        return const HotelSearchForm();
      case SearchTab.package:
        return const PackageSearchForm();
    }
  }
}
