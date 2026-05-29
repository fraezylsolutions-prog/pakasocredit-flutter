import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerSection extends StatelessWidget {
  const DrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final navigationController = Get.find<NavigationController>();

    final List<Map<String, dynamic>> menuItems = [
      {"name": "Deposit", "icon": PngAssets.drawerDepositIcon, "route": BaseRoute.deposit},
      {"name": "Wallets", "icon": PngAssets.drawerWalletIcon, "route": BaseRoute.wallet},
      {"name": "Virtual Cards", "icon": PngAssets.drawerVirtualCardIcon, "route": BaseRoute.virtualCard},
      {"name": "Fund Transfer", "icon": PngAssets.drawerFundTransferIcon, "route": BaseRoute.fundTransfer},
      {"name": "DPS", "icon": PngAssets.drawerDPSIcon, "route": BaseRoute.dpsPlan},
      {"name": "FDR", "icon": PngAssets.drawerFDRIcon, "route": BaseRoute.fdrPlan},
      {"name": "Loan", "icon": PngAssets.drawerLoanIcon, "route": BaseRoute.loanPlan},
      {"name": "Pay Bill", "icon": PngAssets.drawerPayBillIcon, "route": BaseRoute.payBill},
      {"name": "Transactions", "icon": PngAssets.drawerTransactionIcon, "route": BaseRoute.statistics},
      {"name": "Withdraw", "icon": PngAssets.drawerWithdrawIcon, "route": BaseRoute.withdraw},
      {"name": "Referral", "icon": PngAssets.drawerReferralIcon, "route": BaseRoute.referral},
      {"name": "Portfolio", "icon": PngAssets.drawerPortfolioIcon, "route": BaseRoute.portfolio},
      {"name": "Rewards", "icon": PngAssets.drawerRewardIcon, "route": BaseRoute.reward},
      {"name": "Support", "icon": PngAssets.drawerSupportIcon, "route": BaseRoute.helpAndSupport},
      {"name": "Settings", "icon": PngAssets.drawerSettingsIcon, "route": BaseRoute.settings},
    ];

    return Drawer(
      width: 310,
      backgroundColor: themeController.isDarkMode.value ? AppColors.darkSecondary : AppColors.white,
      child: Column(
        children: [
          // Header with Pattern Background to match your screenshot
          Stack(
            children: [
              Container(
                height: 130,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  image: DecorationImage(
                    image: AssetImage(PngAssets.drawerFrame),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 25,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Navigations",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
                  leading: Image.asset(
                    item['icon'], 
                    width: 22, 
                    height: 22, 
                    color: themeController.isDarkMode.value ? AppColors.darkTextPrimary : AppColors.textPrimary
                  ),
                  title: Text(
                    item['name'], 
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)
                  ),
                  onTap: () {
                    Get.back();
                    if (item['route'] != null) {
                      navigationController.pushNamed(item['route']);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
