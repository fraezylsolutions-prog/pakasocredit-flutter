import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/navigation/custom_navigation_item.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/drawer_section.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/end_drawer_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final navigationController = Get.find<NavigationController>();
  final themeController = Get.find<ThemeController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Ensure HomeController has the scaffold key to open the drawer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().setScaffoldKey(_scaffoldKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show main loading if navigation isn't ready
      if (navigationController.isLoading.value) {
        return const Scaffold(body: Center(child: CommonLoading()));
      }

      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: themeController.isDarkMode.value
              ? AppColors.darkBackground
              : AppColors.primary,
        ),
        body: Stack(
          children: [
            // Current Page Content
            GetBuilder<NavigationController>(
              builder: (controller) => controller.currentPage,
            ),
            
            // Loading Overlay for Dashboard data
            if (Get.isRegistered<HomeController>())
              Obx(() => Visibility(
                visible: Get.find<HomeController>().isLoading.value,
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(child: CommonLoading()),
                ),
              )),
          ],
        ),
        bottomNavigationBar: const CustomNavigationItem(),
        drawer: const DrawerSection(),
        endDrawer: const EndDrawerSection(),
      );
    });
  }
}
