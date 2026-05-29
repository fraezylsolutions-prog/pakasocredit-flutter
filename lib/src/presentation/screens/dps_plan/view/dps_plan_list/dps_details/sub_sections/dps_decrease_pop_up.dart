import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_enter_amount_text_field.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/controller/dps_details_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DpsDecreasePopUp extends StatelessWidget {
  const DpsDecreasePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final dpsDetailsController = Get.find<DpsDetailsController>();

    return Dialog(
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 370,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "dpsPlan.dpsPlanList.dpsDetails.dpsDecrease.title".trns(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          themeController.isDarkMode.value
                              ? AppColors.white.withValues(alpha: 0.08)
                              : AppColors.black.withValues(alpha: 0.08),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          PngAssets.commonCancelIcon,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.white.withValues(alpha: 0.5)
                                  : AppColors.black.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color:
                      themeController.isDarkMode.value
                          ? Color(0xFF1C2E24)
                          : Color(0xFFCFF4FC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkCardBorder
                            : Color(0xFF9EEAF9),
                  ),
                ),
                child: Obx(
                  () => Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "dpsPlan.dpsPlanList.dpsDetails.dpsDecrease.currentInstallment"
                                  .trns(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextTertiary
                                    : Color(0xFF055160),
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text:
                              "${dpsDetailsController.dpsDetailsModel.value.data?.perInstallment ?? "N/A"} ",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextTertiary
                                    : Color(0xFF055160),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Obx(
                () => CommonEnterAmountTextField(
                  hintText:
                      "dpsPlan.dpsPlanList.dpsDetails.dpsDecrease.fields.decreaseAmount"
                          .trns(),
                  keyboardType: TextInputType.number,
                  currencyCode: dpsDetailsController.siteCurrency.value,
                  controller: dpsDetailsController.decreaseAmountController,
                ),
              ),
              Obx(
                () => Text(
                  "dpsPlan.dpsPlanList.dpsDetails.dpsDecrease.fields.minMaxValidation"
                      .trnsFormat({
                        "min_range":
                            dpsDetailsController
                                .dpsDetailsModel
                                .value
                                .data
                                ?.minDecreaseAmount ??
                            "N/A",
                        "max_range":
                            dpsDetailsController
                                .dpsDetailsModel
                                .value
                                .data
                                ?.maxDecreaseAmount ??
                            "N/A",
                      }),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    color: AppColors.error,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonElevatedButton(
                    width: 85,
                    height: 32,
                    borderRadius: 6,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    buttonName:
                        "dpsPlan.dpsPlanList.dpsDetails.dpsDecrease.buttons.submit"
                            .trns(),
                    iconSpacing: 4,
                    onPressed: () {
                      Get.back();
                      dpsDetailsController.decreaseDps(
                        id:
                            dpsDetailsController.dpsDetailsModel.value.data!.id
                                .toString(),
                        dpsId:
                            dpsDetailsController
                                .dpsDetailsModel
                                .value
                                .data!
                                .dpsId
                                .toString(),
                      );
                    },
                    leftIcon: Icon(
                      Icons.check,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.black
                              : AppColors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 10),
                  CommonElevatedButton(
                    width: 85,
                    height: 32,
                    borderRadius: 6,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    buttonName:
                        "dpsPlan.dpsPlanList.dpsDetails.dpsDecrease.buttons.close"
                            .trns(),
                    backgroundColor: AppColors.error,
                    textColor: AppColors.white,
                    iconSpacing: 4,
                    onPressed: () => Get.back(),
                    leftIcon: Icon(
                      Icons.clear,
                      color: AppColors.white,
                      size: 16,
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
}
