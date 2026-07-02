import 'dart:convert';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/controller/loan_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_plan_model.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/view/loan_instructions/loan_instructions.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LoanApplicationForm extends StatefulWidget {
  final ConfirmPasscodeController passcodeController;
  final LoanPlanData loanPlanData;

  const LoanApplicationForm({
    super.key,
    required this.loanPlanData,
    required this.passcodeController,
  });

  @override
  State<LoanApplicationForm> createState() => _LoanApplicationFormState();
}

class _LoanApplicationFormState extends State<LoanApplicationForm> {
  final ThemeController themeController = Get.find<ThemeController>();
  final LoanPlanController loanPlanController = Get.find();
  final Map<String, TextEditingController> textControllers = {};

  @override
  void initState() {
    super.initState();
    final List<dynamic> parsedFields = jsonDecode(widget.loanPlanData.fields!);
    for (var field in parsedFields) {
      if (field['type'] == 'text' ||
          field['type'] == 'textarea' ||
          field['type'] == 'select') {
        textControllers.putIfAbsent(
          field['name'],
          () => TextEditingController(),
        );
      }
    }
  }

  @override
  void dispose() {
    textControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> parsedFields = jsonDecode(widget.loanPlanData.fields!);

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
                  title: "loanPlan.loanApplication.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: true,
                  isUtilsBackLogic: true,
                  backLogicFunction: () {
                    Get.find<NavigationController>().popPage();
                    loanPlanController.amountController.clear();
                  },
                  rightSideIcon: PngAssets.commonInstructionsIcon,
                  onPressed: () {
                    Get.find<NavigationController>().pushPage(
                      LoanInstructions(loanPlanData: widget.loanPlanData),
                    );
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          ...parsedFields.map((field) {
                            final String name = field['name'];
                            final String type = field['type'];
                            final dynamic values = field['values'];

                            if (type == 'text') {
                              return Column(
                                children: [
                                  CommonTextInputField(
                                    controller: textControllers[name],
                                    hintText: name,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      loanPlanController.setFormData(
                                        name,
                                        value,
                                      );
                                      textControllers[name]?.text = value;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            } else if (type == 'textarea') {
                              return Column(
                                children: [
                                  CommonTextInputField(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    height: null,
                                    maxLines: 4,
                                    controller: textControllers[name],
                                    hintText: name,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      loanPlanController.setFormData(
                                        name,
                                        value,
                                      );
                                      textControllers[name]?.text = value;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            } else if (type == 'select') {
                              final controller = textControllers[name]!;

                              return Column(
                                children: [
                                  CommonTextInputField(
                                    textFontWeight: FontWeight.w600,
                                    controller: controller,
                                    keyboardType: TextInputType.none,
                                    readOnly: true,
                                    onTap: () {
                                      final List<String> stringValues =
                                          values
                                              .map<String>(
                                                (item) => item.toString(),
                                              )
                                              .toList();

                                      Get.bottomSheet(
                                        CommonDropdownBottomSheet(
                                          title:
                                              "loanPlan.loanApplication.form.select.placeholder"
                                                  .trnsFormat({
                                                    "field_name": name,
                                                  }),
                                          dropdownItems: stringValues,
                                          selectedItem:
                                              controller.text.isNotEmpty
                                                  ? RxString(controller.text)
                                                  : RxString(''),
                                          textController: controller,
                                          currentlySelectedValue:
                                              controller.text.isNotEmpty
                                                  ? controller.text
                                                  : '',
                                          bottomSheetHeight: 400,
                                          onValueSelected: (selectedValue) {
                                            if (selectedValue != null) {
                                              textControllers[name]?.text =
                                                  selectedValue;
                                              loanPlanController.setFormData(
                                                name,
                                                selectedValue,
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    },
                                    hintText:
                                        "loanPlan.loanApplication.form.select.placeholder"
                                            .trnsFormat({"field_name": name}),
                                    showSuffixIcon: true,
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                      color: Colors.grey.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            } else if (type == 'file') {
                              return Column(
                                children: [
                                  _buildUploadSection(
                                    title: name,
                                    fieldName: name,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                          CommonElevatedButton(
                            buttonName:
                                "loanPlan.loanApplication.buttons.applyNow"
                                    .trns(),
                            onPressed: () {
                              final homeCtrl = Get.find<HomeController>();
                              final userPasscode =
                                  homeCtrl.userModel.value.passcode;

                              if (userPasscode == null) {
                                _submitForm();
                                return;
                              }

                              final needsPasscode =
                                  widget
                                          .passcodeController
                                          .passcodeStatus
                                          .value ==
                                      "1" ||
                                  widget
                                          .passcodeController
                                          .passcodeStatus
                                          .value ==
                                      "null";

                              if (needsPasscode) {
                                Get.dialog(
                                  ConfirmPasscodePopUp(
                                    controller:
                                        widget
                                            .passcodeController
                                            .passcodeController,
                                    onPressed: () async {
                                      final ok =
                                          await widget.passcodeController
                                              .submitPasscodeVerify();
                                      if (!ok) return;
                                      Get.back();
                                      _submitForm();
                                    },
                                  ),
                                );
                              } else {
                                _submitForm();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: loanPlanController.isApplyNowLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection({
    required String title,
    required String fieldName,
  }) {
    return Obx(() {
      final selectedImage = loanPlanController.selectedImages[fieldName];

      return GestureDetector(
        onTap: () {
          _showImagePickerOptions(fieldName);
        },
        child: SizedBox(
          width: double.infinity,
          height: 130,
          child:
              selectedImage != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(selectedImage, fit: BoxFit.cover),
                  )
                  : Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        themeController.isDarkMode.value
                            ? PngAssets.commonDarkAttachFile
                            : PngAssets.commonAttachFile,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            PngAssets.commonUploadIcon,
                            width: 18,
                            fit: BoxFit.contain,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextTertiary
                                    : AppColors.textTertiary,
                          ),
                          SizedBox(height: 8),
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkTextTertiary
                                      : AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
        ),
      );
    });
  }

  void _showImagePickerOptions(String fieldName) {
    Get.bottomSheet(
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuart,
        height: 230,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeController.isDarkMode.value
                  ? AppColors.darkSecondary.withValues(alpha: 0.95)
                  : AppColors.white.withValues(alpha: 0.95),
              themeController.isDarkMode.value
                  ? AppColors.darkSecondary.withValues(alpha: 0.95)
                  : AppColors.white.withValues(alpha: 0.95),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkCardBorder
                    : AppColors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.white.withValues(alpha: 0.3)
                                : AppColors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Text(
                          "loanPlan.loanApplication.imageUpload.title".trns(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                          onPressed: () => Navigator.pop(context),
                          splashRadius: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      loanPlanController.pickImage(
                        fieldName,
                        ImageSource.camera,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkCardBorder
                                      : AppColors.textTertiary.withValues(
                                        alpha: 0.2,
                                      ),
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.asset(
                            PngAssets.cameraCommonIconTwo,
                            width: 30,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "loanPlan.loanApplication.imageUpload.camera".trns(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      loanPlanController.pickImage(
                        fieldName,
                        ImageSource.gallery,
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkCardBorder
                                      : AppColors.textTertiary.withValues(
                                        alpha: 0.2,
                                      ),
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.asset(
                            PngAssets.galleryCommonIcon,
                            width: 30,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "loanPlan.loanApplication.imageUpload.gallery".trns(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ],
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

  void _submitForm() {
    textControllers.forEach((fieldName, controller) {
      loanPlanController.setFormData(fieldName, controller.text);
    });

    final List<dynamic> parsedFields = jsonDecode(widget.loanPlanData.fields!);
    bool isValid = true;

    for (var field in parsedFields) {
      if (field['validation'] == 'required') {
        final fieldName = field['name'];
        final fieldType = field['type'];

        if (fieldType == 'text' || fieldType == 'textarea') {
          if (textControllers[fieldName]?.text.isEmpty ?? true) {
            isValid = false;
            Fluttertoast.showToast(
              msg: "loanPlan.loanApplication.validation.fieldRequired"
                  .trnsFormat({"field_name": fieldName}),
              backgroundColor: AppColors.error,
            );
          }
        } else if (fieldType == 'select') {
          if (textControllers[fieldName]?.text.isEmpty ?? true) {
            isValid = false;
            Fluttertoast.showToast(
              msg: "loanPlan.loanApplication.validation.selectField".trnsFormat(
                {"field_name": fieldName},
              ),
              backgroundColor: AppColors.error,
            );
          }
        } else if (fieldType == 'file') {
          if (!loanPlanController.selectedImages.containsKey(fieldName)) {
            isValid = false;
            Fluttertoast.showToast(
              msg: "loanPlan.loanApplication.validation.fieldRequired"
                  .trnsFormat({"field_name": fieldName}),
              backgroundColor: AppColors.error,
            );
          }
        }
      }
    }

    if (isValid) {
      loanPlanController.submitApplyLoanForm(widget.loanPlanData.id!);
    }
  }
}
