import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/model/beneficiary_details_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeneficiaryDetailsDialogSection extends StatelessWidget {
  final BeneficiaryDetailsModel beneficiaryDetailsModel;

  const BeneficiaryDetailsDialogSection({
    super.key,
    required this.beneficiaryDetailsModel,
  });

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
                "fundTransfer.beneficiaryList.beneficiaryDetails.labels.bankName"
                    .trns(),
                beneficiaryDetailsModel.data!.bank!.name ?? "Own Bank",
              ),
              SizedBox(height: 16),
              Divider(
                height: 0,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.black.withValues(alpha: 0.05),
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                "fundTransfer.beneficiaryList.beneficiaryDetails.labels.accountNumber"
                    .trns(),
                beneficiaryDetailsModel.data!.accountNumber ?? "N/A",
              ),
              SizedBox(height: 16),
              Divider(
                height: 0,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.black.withValues(alpha: 0.05),
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                "fundTransfer.beneficiaryList.beneficiaryDetails.labels.accountName"
                    .trns(),
                beneficiaryDetailsModel.data!.accountName ?? "N/A",
              ),
              SizedBox(height: 16),
              Divider(
                height: 0,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.black.withValues(alpha: 0.05),
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                "fundTransfer.beneficiaryList.beneficiaryDetails.labels.branchName"
                    .trns(),
                beneficiaryDetailsModel.data!.branchName ?? "N/A",
              ),
              SizedBox(height: 16),
              Divider(
                height: 0,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.black.withValues(alpha: 0.05),
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                "fundTransfer.beneficiaryList.beneficiaryDetails.labels.nickName"
                    .trns(),
                beneficiaryDetailsModel.data!.nickName ?? "N/A",
              ),
              if (beneficiaryDetailsModel.data!.bank!.dailyLimitMaximumAmount !=
                  null)
                Column(
                  children: [
                    SizedBox(height: 16),
                    Divider(
                      height: 0,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkCardBorder
                              : AppColors.black.withValues(alpha: 0.05),
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow(
                      "fundTransfer.beneficiaryList.beneficiaryDetails.labels.dailyLimit"
                          .trns(),
                      "${"fundTransfer.beneficiaryList.beneficiaryDetails.values.maxLimit".trns()} ${beneficiaryDetailsModel.data!.bank!.dailyLimitMaximumAmount ?? "N/A"} USD",
                    ),
                  ],
                ),
              if (beneficiaryDetailsModel
                      .data!
                      .bank!
                      .monthlyLimitMaximumAmount !=
                  null)
                Column(
                  children: [
                    SizedBox(height: 16),
                    Divider(
                      height: 0,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkCardBorder
                              : AppColors.black.withValues(alpha: 0.05),
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow(
                      "fundTransfer.beneficiaryList.beneficiaryDetails.labels.monthlyLimit"
                          .trns(),
                      "${"fundTransfer.beneficiaryList.beneficiaryDetails.values.maxLimit".trns()} ${beneficiaryDetailsModel.data!.bank!.monthlyLimitMaximumAmount ?? "N/A"} USD",
                    ),
                  ],
                ),
              SizedBox(height: 16),
              Divider(
                height: 0,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.black.withValues(alpha: 0.05),
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                "fundTransfer.beneficiaryList.beneficiaryDetails.labels.chargePerTransfer"
                    .trns(),
                "${beneficiaryDetailsModel.data!.bank!.charge ?? "N/A"} ${beneficiaryDetailsModel.data!.bank!.chargeType == "percentage" ? "%" : ""}",
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
          "fundTransfer.beneficiaryList.beneficiaryDetails.title".trns(),
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
            onTap: () => Get.back(),
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

  Widget _buildDetailRow(String label, String value) {
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
                themeController.isDarkMode.value
                    ? AppColors.darkPrimary
                    : AppColors.primary,
          ),
        ),
      ],
    );
  }
}
