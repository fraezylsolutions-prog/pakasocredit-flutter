import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/controller/deposit_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepositReviewDetailsSection extends StatelessWidget {
  final ConfirmPasscodeController passcodeController;

  const DepositReviewDetailsSection({
    super.key,
    required this.passcodeController,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final DepositController depositController = Get.find<DepositController>();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkCardBorder
                  : Color(0xFFE6E6E6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "deposit.review.title".trns(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Divider(
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkCardBorder
                    : Color(0xFF000000).withValues(alpha: 0.10),
            height: 0,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "deposit.review.amount.label".trns(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              Obx(
                () => Visibility(
                  visible: depositController.gateway.isNotEmpty,
                  child: Text(
                    "${depositController.amount.value.isNotEmpty ? double.tryParse(depositController.amount.value)?.toStringAsFixed(0) : "0"} ${depositController.copyCurrencyCode.value}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "deposit.review.charge.label".trns(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              Obx(
                () => Visibility(
                  visible: depositController.gateway.isNotEmpty,
                  child: Text(
                    "${depositController.chargeAmount.value == 0.0 ? "0" : depositController.chargeAmount.value.toStringAsFixed(2)} ${depositController.copyCurrencyCode.value}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "deposit.review.paymentMethod.label".trns(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              Obx(
                () => Visibility(
                  visible: depositController.gateway.value.isNotEmpty,
                  child: Text(
                    depositController.gateway.value,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "deposit.review.paymentMethodLogo.label".trns(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              Obx(
                () => Visibility(
                  visible: depositController.gateway.value.isNotEmpty,
                  child: Image.network(
                    depositController.gatewayLogo.value,
                    width: 30,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error_outline_outlined,
                        color: AppColors.error.withValues(alpha: 0.5),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Visibility(
              visible:
                  depositController.currencyCode.value !=
                  depositController.siteCurrency.value,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "deposit.review.conversionRate.label".trns(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: depositController.gateway.isNotEmpty,
                          child: Text(
                            "1 ${depositController.copyCurrencyCode.value} = ${depositController.isGatewayRate.value} ${depositController.gatewayCurrencyCode.value}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "deposit.review.total.label".trns(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              Obx(
                () => Visibility(
                  visible: depositController.gateway.isNotEmpty,
                  child: Text(
                    "${depositController.totalAmount.value == 0.0 ? "0" : depositController.totalAmount.value.toStringAsFixed(2)} ${depositController.copyCurrencyCode.value}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "deposit.review.payable.label".trns(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              Obx(
                () => Visibility(
                  visible: depositController.gateway.isNotEmpty,
                  child: Text(
                    "${depositController.payAmount.value == 0.0 ? "0" : depositController.payAmount.value.toStringAsFixed(2)} ${depositController.gatewayCurrencyCode.value}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          CommonElevatedButton(
            height: 45,
            buttonName: "deposit.button.proceed".trns(),
            onPressed: () {
              final homeCtrl = Get.find<HomeController>();
              final userPasscode = homeCtrl.userModel.value.passcode;
              final isAuto = depositController.paymentType.value == "auto";

              if (userPasscode == null) {
                if (isAuto) {
                  depositController.submitDepositAuto();
                } else {
                  depositController.submitDepositManual();
                }
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
                      if (isAuto) {
                        depositController.submitDepositAuto();
                      } else {
                        depositController.submitDepositManual();
                      }
                    },
                  ),
                );
              } else {
                if (isAuto) {
                  depositController.submitDepositAuto();
                } else {
                  depositController.submitDepositManual();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
