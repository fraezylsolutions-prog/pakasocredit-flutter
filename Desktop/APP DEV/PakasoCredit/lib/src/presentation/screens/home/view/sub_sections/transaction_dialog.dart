import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/presentation/screens/home/model/dashboard_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDialog extends StatelessWidget {
  final Transactions controller;

  const TransactionDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Dialog(
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.description!,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "home.recentTransactions.dialog.time".trns(),
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
                    controller.createdAt!,
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
                        ? AppColors.darkTextPrimary.withValues(alpha: 0.06)
                        : AppColors.textPrimary.withValues(alpha: 0.06),
                height: 0,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "home.recentTransactions.dialog.transactionId".trns(),
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
                    controller.tnx!,
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
                        ? AppColors.darkTextPrimary.withValues(alpha: 0.06)
                        : AppColors.textPrimary.withValues(alpha: 0.06),
                height: 0,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "home.recentTransactions.dialog.amount".trns(),
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
                    "${controller.isPlus == true ? "+" : "-"}${controller.amount}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color:
                          controller.isPlus == true
                              ? AppColors.success
                              : AppColors.error,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary.withValues(alpha: 0.06)
                        : AppColors.textPrimary.withValues(alpha: 0.06),
                height: 0,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "home.recentTransactions.dialog.charge".trns(),
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
                    "-${controller.charge}",
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
                        ? AppColors.darkTextPrimary.withValues(alpha: 0.06)
                        : AppColors.textPrimary.withValues(alpha: 0.06),
                height: 0,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "home.recentTransactions.dialog.status".trns(),
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
                      color:
                          controller.status == "Success"
                              ? AppColors.success.withValues(alpha: 0.10)
                              : controller.status == "Pending"
                              ? Colors.orange.withValues(alpha: 0.10)
                              : AppColors.error.withValues(alpha: 0.10),
                    ),
                    child: Text(
                      controller.status!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                        color:
                            controller.status == "Success"
                                ? AppColors.success
                                : controller.status == "Pending"
                                ? Colors.orange
                                : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary.withValues(alpha: 0.06)
                        : AppColors.textPrimary.withValues(alpha: 0.06),
                height: 0,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "home.recentTransactions.dialog.method".trns(),
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
                    controller.method!,
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
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: CommonElevatedButton(
                  width: 85,
                  height: 34,
                  borderRadius: 8,
                  buttonName:
                      "home.recentTransactions.dialog.closeButtonText".trns(),
                  onPressed: () => Get.back(),
                  fontSize: 13,
                  iconSpacing: 3,
                  leftIcon: Icon(
                    Icons.close,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.black
                            : AppColors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
