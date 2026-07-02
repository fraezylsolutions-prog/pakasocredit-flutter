import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/fund_transfer_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/transfer_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarSection extends StatelessWidget {
  final FundTransferController fundTransferController;

  const TabBarSection({super.key, required this.fundTransferController});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
        decoration: BoxDecoration(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkSecondary
                  : Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(
          () => Row(
            children: [
              _buildTabButton(
                label: "fundTransfer.tabBar.transfer".trns(),
                index: 0,
                controller: fundTransferController,
              ),
              SizedBox(width: 10),
              _buildTabButton(
                label: "fundTransfer.tabBar.beneficiaries".trns(),
                index: 1,
                controller: fundTransferController,
              ),
              SizedBox(width: 10),
              _buildTabButton(
                label: "Initiate Transfer",
                index: 2,
                controller: fundTransferController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required int index,
    required FundTransferController controller,
  }) {
    final ThemeController themeController = Get.find<ThemeController>();
    bool isSelected = controller.selectedTab.value == index;

    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          overlayColor:
              themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide.none,
          backgroundColor:
              isSelected
                  ? themeController.isDarkMode.value
                      ? Color(0xFF1C2E24)
                      : AppColors.white
                  : AppColors.transparent,
        ),
        onPressed: () {
          controller.selectedTab.value = index;
          if (index == 0 || index == 1 || index == 2) {
            Get.find<TransferController>().isSendMoney.value = false;
          }
        },
        child: Text(
          textAlign: TextAlign.center,
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11.5,
            color:
                isSelected
                    ? themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary
                    : themeController.isDarkMode.value
                    ? AppColors.darkTextTertiary
                    : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
