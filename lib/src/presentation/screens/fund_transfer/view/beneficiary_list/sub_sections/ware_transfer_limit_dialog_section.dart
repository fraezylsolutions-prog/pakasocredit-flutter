import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WareTransferLimitDialogSection extends StatelessWidget {
  const WareTransferLimitDialogSection({super.key});

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildDetailRow(
                "fundTransfer.wireTransferLimit.limits.minPerTransaction"
                    .trns(),
                "10.00 USD",
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                "fundTransfer.wireTransferLimit.limits.maxPerTransaction"
                    .trns(),
                "10000.00 USD",
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                "fundTransfer.wireTransferLimit.limits.dailyMaxTransfer".trns(),
                "100000.00 USD",
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                "fundTransfer.wireTransferLimit.limits.monthlyMaxTransfer"
                    .trns(),
                "5000000.00 USD",
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                "fundTransfer.wireTransferLimit.limits.dailyTransactionLimit"
                    .trns(),
                "5 Times",
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                "fundTransfer.wireTransferLimit.limits.monthlyTransactionLimit"
                    .trns(),
                "100 Times",
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                "fundTransfer.wireTransferLimit.limits.perTransactionFee"
                    .trns(),
                "10 %",
                valueColor: AppColors.error,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final ThemeController themeController = Get.find<ThemeController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "fundTransfer.wireTransferLimit.title".trns(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
          ),
        ),
        Transform.translate(
          offset: Offset(8, 0),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Get.back();
            },
            child: CircleAvatar(
              radius: 15,
              backgroundColor:
                  themeController.isDarkMode.value
                      ? AppColors.white.withValues(alpha: 0.05)
                      : AppColors.black.withValues(alpha: 0.05),
              child: Image.asset(
                PngAssets.commonCancelIcon,
                width: 14,
                fit: BoxFit.contain,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.white
                        : AppColors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color:
                valueColor == null
                    ? themeController.isDarkMode.value
                        ? AppColors.darkPrimary
                        : AppColors.primary
                    : AppColors.error,
          ),
        ),
      ],
    );
  }
}
