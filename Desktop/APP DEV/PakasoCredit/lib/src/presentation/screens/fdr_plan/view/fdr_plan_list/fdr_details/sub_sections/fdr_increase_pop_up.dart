import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_enter_amount_text_field.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/controller/fdr_details_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FdrIncreasePopUp extends StatelessWidget {
  const FdrIncreasePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final fdrDetailsController = Get.find<FdrDetailsController>();
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
                    "fdrPlan.fdrPlanList.fdrDetails.fdrIncrease.title".trns(),
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
              Obx(
                () => CommonEnterAmountTextField(
                  hintText:
                      "fdrPlan.fdrPlanList.fdrDetails.fdrIncrease.increaseAmount"
                          .trns(),
                  keyboardType: TextInputType.number,
                  currencyCode: fdrDetailsController.siteCurrency.value,
                  controller: fdrDetailsController.increaseAmountController,
                ),
              ),
              Obx(
                () => Text(
                  "fdrPlan.fdrPlanList.fdrDetails.fdrIncrease.amountLimits"
                      .trnsFormat({
                        "min_amount":
                            fdrDetailsController
                                .fdrDetailsModel
                                .value
                                .data
                                ?.minIncreaseAmount ??
                            "N/A",
                        "max_amount":
                            fdrDetailsController
                                .fdrDetailsModel
                                .value
                                .data
                                ?.maxIncreaseAmount ??
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
                        "fdrPlan.fdrPlanList.fdrDetails.fdrIncrease.submit"
                            .trns(),
                    iconSpacing: 4,
                    onPressed: () {
                      Get.back();
                      fdrDetailsController.increaseFdr(
                        id:
                            fdrDetailsController.fdrDetailsModel.value.data!.id
                                .toString(),
                        fdrId:
                            fdrDetailsController
                                .fdrDetailsModel
                                .value
                                .data!
                                .fdrId
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
                        "fdrPlan.fdrPlanList.fdrDetails.fdrIncrease.close"
                            .trns(),
                    backgroundColor: AppColors.error,
                    iconSpacing: 4,
                    onPressed: () => Get.back(),
                    textColor: AppColors.white,
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
