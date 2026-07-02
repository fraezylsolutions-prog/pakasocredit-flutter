import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/bill_payment_history_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/bill_payment_history_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPayBillHistoryDialog extends StatelessWidget {
  final BillPaymentHistoryData billPaymentHistoryData;

  const AllPayBillHistoryDialog({
    super.key,
    required this.billPaymentHistoryData,
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
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "payBill.billPaymentHistory.dialog.title".trns(),
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
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "payBill.billPaymentHistory.dialog.time".trns(),
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
                    billPaymentHistoryData.createdAt!,
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
              ),
              SizedBox(height: 16),
              Divider(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.textPrimary.withValues(alpha: 0.06),
                height: 0,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "payBill.billPaymentHistory.dialog.amount".trns(),
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
                    "${billPaymentHistoryData.amount!} ${Get.find<BillPaymentHistoryController>().siteCurrency.value}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.textPrimary.withValues(alpha: 0.06),
                height: 0,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "payBill.billPaymentHistory.dialog.charge".trns(),
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
                    "${billPaymentHistoryData.charge} ${Get.find<BillPaymentHistoryController>().siteCurrency.value}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.textPrimary.withValues(alpha: 0.06),
                height: 0,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "payBill.billPaymentHistory.dialog.method".trns(),
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
                    "${billPaymentHistoryData.method}",
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
              ),
              SizedBox(height: 16),
              Divider(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.textPrimary.withValues(alpha: 0.06),
                height: 0,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "payBill.billPaymentHistory.dialog.status".trns(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: AppColors.success.withValues(alpha: 0.10),
                    ),
                    child: Text(
                      billPaymentHistoryData.status!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              if (billPaymentHistoryData.metadata != null) ...[
                SizedBox(height: 16),
                Divider(
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkCardBorder
                          : AppColors.textPrimary.withValues(alpha: 0.06),
                  height: 0,
                ),
                SizedBox(height: 16),
                ...billPaymentHistoryData.metadata!.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            entry.value.toString(),
                            textAlign: TextAlign.end,
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
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
