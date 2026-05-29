import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepositPending extends StatelessWidget {
  final String amount;
  final String transaction;

  const DepositPending({
    super.key,
    required this.amount,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkSecondary
                      : Color(0xFFFAFAF5),
              boxShadow: AppStyles.boxShadow(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color:
                        themeController.isDarkMode.value
                            ? Color(0xFF1C2E24)
                            : Color(0xFF1E7745),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.water_drop_outlined,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextTertiary
                              : AppColors.white,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  textAlign: TextAlign.center,
                  '$amount ${"deposit.deposit_pending.depositPendingText".trns()}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'deposit.deposit_pending.description'.trns(),
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextTertiary
                              : AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '${"deposit.deposit_pending.transactionId".trns()}: $transaction',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextTertiary
                            : AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: 40),
                CommonElevatedButton(
                  width: 150,
                  height: 45,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  borderRadius: 30,
                  backgroundColor: Color(0xFF81EF71),
                  buttonName:
                      "deposit.deposit_pending.depositAgainButtonText".trns(),
                  onPressed: () {
                    Get.find<NavigationController>().popPage();
                  },
                  textColor: Color(0xFF1F1F1F),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
