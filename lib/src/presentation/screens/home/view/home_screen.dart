import 'package:pakaso_credit/src/common/widgets/common_alert_dialog.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/alert_box_section.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/card_slider_section.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/currency_section.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/earn_section.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/quick_access_section.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/recent_transaction_section.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/top_bar_section.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/transaction_overview_section.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        showExitApplicationAlertDialog();
      },
      child: Scaffold(
        body: Obx(
          () => homeController.isDashboardLoading.value
              ? const Center(child: CommonLoading())
              : RefreshIndicator(
                  onRefresh: () => homeController.loadData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 50), // Added spacing for status bar
                        const TopBarSection(),
                        const AlertBoxSection(),
                        const SizedBox(height: 20),
                        const EarnSection(),
                        const SizedBox(height: 20),
                        const AccountOverviewSection(),
                        const SizedBox(height: 20),
                        const CurrencyCardSection(),
                        const SizedBox(height: 20),
                        const QuickAccessSection(),
                        const SizedBox(height: 20),
                        const TransactionOverviewSection(),
                        const SizedBox(height: 20),
                        const RecentTransactionSection(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void showExitApplicationAlertDialog() {
    Get.dialog(
      CommonAlertDialog(
        title: "home.exitDialog.title".trns(),
        message: "home.exitDialog.message".trns(),
        onConfirm: () {
          Get.find<HomeController>().submitLogout();
          SystemNavigator.pop();
        },
        onCancel: () => Get.back(),
      ),
    );
  }
}
