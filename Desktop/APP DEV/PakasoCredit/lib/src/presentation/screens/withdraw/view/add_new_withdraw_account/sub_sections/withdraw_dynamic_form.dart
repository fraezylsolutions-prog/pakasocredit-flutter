import 'dart:convert';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/controller/add_new_withdraw_account_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class WithdrawDynamicForm extends StatefulWidget {
  const WithdrawDynamicForm({super.key});

  @override
  State<WithdrawDynamicForm> createState() => _WithdrawDynamicFormState();
}

class _WithdrawDynamicFormState extends State<WithdrawDynamicForm> {
  final ThemeController themeController = Get.find();
  final AddNewWithdrawAccountController accountController = Get.find();

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> parsedFields = jsonDecode(
      accountController.gatewayFields.value,
    );
    parsedFields.forEach((key, field) {
      if (field['type'] == 'text' ||
          field['type'] == 'textarea' ||
          field['type'] == 'file') {
        accountController.textControllers[field['name']] =
            TextEditingController();
      }
    });
  }

  @override
  void dispose() {
    accountController.textControllers.forEach(
      (_, controller) => controller.dispose(),
    );
    super.dispose();
  }

  String formatFieldName(String name) {
    return name
        .split('_')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> parsedFields = jsonDecode(
      accountController.gatewayFields.value,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          ...parsedFields.entries.map((entry) {
            final field = entry.value;
            final String name = field['name'];
            final String type = field['type'];

            if (type == 'text') {
              return Column(
                children: [
                  CommonTextInputField(
                    controller: accountController.textControllers[name],
                    hintText: name,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      accountController.setFormData(name, value);
                      accountController.textControllers[name]?.text = value;
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
                    controller: accountController.textControllers[name],
                    hintText: name,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      accountController.setFormData(name, value);
                      accountController.textControllers[name]?.text = value;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              );
            } else if (type == 'file') {
              return Column(
                children: [
                  _buildUploadSection(title: name, fieldName: name),
                  const SizedBox(height: 16),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),

          CommonElevatedButton(
            buttonName: "withdraw.addWithdrawAccount.addButton".trns(),
            onPressed: () {
              _submitForm();
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildUploadSection({
    required String title,
    required String fieldName,
  }) {
    return Obx(() {
      final selectedImage = accountController.selectedImages[fieldName];

      return GestureDetector(
        onTap: () {
          _showImagePickerOptions(fieldName);
        },
        child: SizedBox(
          width: double.infinity,
          height: selectedImage != null ? 120 : null,
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
                  ? AppColors.darkSecondary
                  : AppColors.white.withValues(alpha: 0.95),
              themeController.isDarkMode.value
                  ? AppColors.darkSecondary
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "withdraw.addWithdrawAccount.imageSource.title"
                              .trns(),
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
                        Transform.translate(
                          offset: const Offset(20, 0),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkTextTertiary
                                      : AppColors.textTertiary,
                            ),
                            onPressed: () => Navigator.pop(context),
                            splashRadius: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      accountController.pickImage(
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
                                    ? AppColors.white
                                    : AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "withdraw.addWithdrawAccount.imageSource.camera"
                              .trns(),
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
                      accountController.pickImage(
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
                                    ? AppColors.white
                                    : AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "withdraw.addWithdrawAccount.imageSource.gallery"
                              .trns(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.white
                                    : AppColors.black,
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
    accountController.textControllers.forEach((fieldName, controller) {
      accountController.setFormData(fieldName, controller.text);
    });

    final Map<String, dynamic> parsedFields = jsonDecode(
      accountController.gatewayFields.value,
    );
    bool isValid = true;

    parsedFields.forEach((key, field) {
      if (field['validation'] == 'required') {
        final fieldName = field['name'];

        if ((field['type'] == 'text' || field['type'] == 'textarea') &&
            (accountController.textControllers[fieldName]?.text.isEmpty ??
                true)) {
          isValid = false;
          Fluttertoast.showToast(
            msg: "withdraw.addWithdrawAccount.validation.required".trnsFormat({
              "field_name": fieldName,
            }),
            backgroundColor: AppColors.error,
          );
        } else if (field['type'] == 'file' &&
            !accountController.selectedImages.containsKey(fieldName)) {
          isValid = false;
          Fluttertoast.showToast(
            msg: "withdraw.addWithdrawAccount.validation.required".trnsFormat({
              "field_name": fieldName,
            }),
            backgroundColor: AppColors.error,
          );
        }
      }
    });

    if (isValid) {
      accountController.submitAddWithdrawAccount();
    }
  }
}
