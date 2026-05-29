import 'dart:convert';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/controller/add_new_withdraw_account_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/add_new_withdraw_account/sub_sections/withdraw_dynamic_form.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewWithdrawAccount extends StatefulWidget {
  const AddNewWithdrawAccount({super.key});

  @override
  State<AddNewWithdrawAccount> createState() => _AddNewWithdrawAccountState();
}

class _AddNewWithdrawAccountState extends State<AddNewWithdrawAccount> {
  final ThemeController themeController = Get.find<ThemeController>();
  final AddNewWithdrawAccountController controller = Get.put(
    AddNewWithdrawAccountController(),
  );

  @override
  void initState() {
    super.initState();
    controller.clearData();
    controller.fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 16),
                CommonAppBar(
                  title: "withdraw.addWithdrawAccount.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: false,
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const CommonLoading();
                    }

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.only(left: 18, right: 18, top: 20),
                      decoration: BoxDecoration(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkSecondary
                                : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        gradient: AppStyles.linearGradient(),
                        boxShadow: AppStyles.boxShadow(),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CommonTextInputField(
                              textFontWeight: FontWeight.w600,
                              controller: controller.gatewayController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheet(
                                    title:
                                        "withdraw.addWithdrawAccount.selectGateway"
                                            .trns(),
                                    onValueSelected: (value) {
                                      controller.gatewayFields.value = "";
                                      controller.textControllers.forEach((
                                        fieldName,
                                        textCtrl,
                                      ) {
                                        textCtrl.clear();
                                      });
                                      controller.textControllers.clear();
                                      controller.formData.clear();
                                      controller.selectedImages.clear();
                                      controller.gateway.value = value;
                                      controller.gatewayController.text = value;
                                      int index = controller.withdrawMethodList
                                          .indexWhere(
                                            (item) => item.name == value,
                                          );

                                      if (index != -1) {
                                        controller.gatewayId.value =
                                            controller
                                                .withdrawMethodList[index]
                                                .id
                                                .toString();
                                        controller.methodCurrency.value =
                                            controller
                                                .withdrawMethodList[index]
                                                .currency
                                                .toString();
                                        controller.methodNameController.text =
                                            "$value-${controller.methodCurrency.value}";
                                        controller.gatewayFields.value =
                                            controller
                                                .withdrawMethodList[index]
                                                .fields
                                                .toString();

                                        final Map<String, dynamic>
                                        parsedFields = jsonDecode(
                                          controller.gatewayFields.value,
                                        );
                                        parsedFields.forEach((key, field) {
                                          if (field['type'] == 'text' ||
                                              field['type'] == 'textarea' ||
                                              field['type'] == 'file') {
                                            controller
                                                    .textControllers[field['name']] =
                                                TextEditingController();
                                          }
                                        });
                                      } else {
                                        controller.gatewayId.value = "";
                                        controller.methodCurrency.value = "";
                                        controller.gatewayFields.value = "";
                                        controller.methodNameController.clear();
                                        controller.formData.clear();
                                        controller.textControllers.clear();
                                      }

                                      Get.back();
                                    },
                                    selectedValue:
                                        controller.withdrawMethodList
                                            .map((item) => item.name!)
                                            .toList(),
                                    dropdownItems:
                                        controller.withdrawMethodList
                                            .map((item) => item.name!)
                                            .toList(),
                                    selectedItem: controller.gateway,
                                    textController:
                                        controller.gatewayController,
                                    currentlySelectedValue:
                                        controller.gateway.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "withdraw.addWithdrawAccount.selectGateway"
                                      .trns(),
                              showSuffixIcon: true,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: Colors.grey.withValues(alpha: 0.8),
                              ),
                            ),
                            SizedBox(height: 16),
                            CommonTextInputField(
                              controller: controller.methodNameController,
                              hintText:
                                  "withdraw.addWithdrawAccount.methodName"
                                      .trns(),
                              keyboardType: TextInputType.text,
                            ),
                            Obx(
                              () =>
                                  controller.gatewayFields.isNotEmpty
                                      ? WithdrawDynamicForm()
                                      : SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: controller.isAddAccountLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
