import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_enter_amount_text_field.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/controller/fdr_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/model/fdr_plan_model.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribeDialogSection extends StatelessWidget {
  final FdrPlanData fdrPlanData;
  final ConfirmPasscodeController passcodeController;

  const SubscribeDialogSection({
    super.key,
    required this.fdrPlanData,
    required this.passcodeController,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final FdrPlanController fdrPlanController = Get.find();

    return Dialog(
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "fdrPlan.fdrSubscribe.title".trns(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => Get.back(),
                  child: CircleAvatar(
                    radius: 14,
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
              ],
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => CommonEnterAmountTextField(
                    hintText: "fdrPlan.fdrSubscribe.fields.enterAmount".trns(),
                    keyboardType: TextInputType.number,
                    currencyCode: fdrPlanController.siteCurrency.value,
                    controller: fdrPlanController.amountController,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "fdrPlan.fdrSubscribe.fields.amountRange".trnsFormat({
                    "min_range": "${fdrPlanData.minimumAmount}",
                    "max_range": "${fdrPlanData.maximumAmount}",
                  }),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 8,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            CommonElevatedButton(
              width: 92,
              height: 32,
              borderRadius: 6,
              iconSpacing: 4,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              buttonName: "fdrPlan.fdrSubscribe.buttons.applyNow".trns(),
              onPressed: () {
                Get.back();
                final homeCtrl = Get.find<HomeController>();
                final userPasscode = homeCtrl.userModel.value.passcode;

                if (userPasscode == null) {
                  fdrPlanController.submitSubscribe(
                    planId: fdrPlanData.id.toString(),
                  );
                  return;
                }

                final needsPasscode =
                    passcodeController.passcodeStatus.value == "1" ||
                    passcodeController.passcodeStatus.value == "null";

                if (needsPasscode) {
                  Get.dialog(
                    ConfirmPasscodePopUp(
                      controller: passcodeController.passcodeController,
                      onPressed: () async {
                        final ok =
                            await passcodeController.submitPasscodeVerify();
                        if (!ok) return;
                        Get.back();
                        fdrPlanController.submitSubscribe(
                          planId: fdrPlanData.id.toString(),
                        );
                      },
                    ),
                  );
                } else {
                  fdrPlanController.submitSubscribe(
                    planId: fdrPlanData.id.toString(),
                  );
                }
              },
              leftIcon: Image.asset(
                PngAssets.commonTickIcon,
                width: 14,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.black
                        : AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
