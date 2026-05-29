import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/controller/wallet_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletDeletePopUp extends StatelessWidget {
  final String walletId;

  const WalletDeletePopUp({super.key, required this.walletId});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xFFFF394B).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Image.asset(PngAssets.commonAlertIcon, width: 30),
              ),
              const SizedBox(height: 16),
              Text(
                "wallet.delete.popup.title".trns(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "wallet.delete.popup.message".trns(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextTertiary
                          : AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonElevatedButton(
                    borderRadius: 6,
                    width: 70,
                    height: 32,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    buttonName: "wallet.delete.popup.buttons.close".trns(),
                    onPressed: () => Get.back(),
                    leftIcon: Image.asset(
                      PngAssets.commonCancelIcon,
                      width: 14,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.black
                              : AppColors.white,
                    ),
                    iconSpacing: 4,
                  ),
                  const SizedBox(width: 10),
                  CommonElevatedButton(
                    borderRadius: 6,
                    width: 120,
                    height: 32,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    buttonName: "wallet.delete.popup.buttons.confirm".trns(),
                    onPressed: () {
                      Get.find<WalletController>().deleteWallet(
                        walletId: walletId,
                      );
                      Get.back();
                    },
                    leftIcon: Image.asset(
                      PngAssets.commonDeleteIcon,
                      width: 14,
                      color: AppColors.white,
                    ),
                    iconSpacing: 4,
                    backgroundColor: AppColors.error,
                    textColor: AppColors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
