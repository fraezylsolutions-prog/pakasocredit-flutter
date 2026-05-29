import 'dart:convert';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/controller/deposit_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DepositManualDynamicFields extends StatefulWidget {
  const DepositManualDynamicFields({super.key});

  @override
  State<DepositManualDynamicFields> createState() =>
      _DepositManualDynamicFieldsState();
}

class _DepositManualDynamicFieldsState
    extends State<DepositManualDynamicFields> {
  final ThemeController themeController = Get.find<ThemeController>();
  final DepositController depositController = Get.find<DepositController>();
  final Map<String, TextEditingController> textControllers = {};

  @override
  void dispose() {
    for (var controller in textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (depositController.gatewayFieldOptions.value.isEmpty) {
        return const SizedBox.shrink();
      }

      try {
        final Map<String, dynamic> parsedFields = jsonDecode(
          depositController.gatewayFieldOptions.value,
        );

        if (parsedFields.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            ...parsedFields.entries.map((entry) {
              final field = entry.value;
              final String name = field['name'];
              final String type = field['type'];

              if (type == 'text') {
                return Column(
                  children: [
                    CommonTextInputField(
                      controller: textControllers[name],
                      hintText: name,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        depositController.setFormData(name, value);
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
                      height: null,
                      maxLines: 5,
                      controller: textControllers[name],
                      hintText: name,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        depositController.setFormData(name, value);
                        textControllers[name]?.text = value;
                      },
                    ),
                    const SizedBox(height: 16),
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
          ],
        );
      } catch (e) {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildUploadSection({
    required String title,
    required String fieldName,
  }) {
    return Obx(() {
      final selectedImage = depositController.selectedImages[fieldName];

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
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkSecondary
                  : AppColors.white,
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
                          "deposit.imagePicker.selectImageSource".trns(),
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
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
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
                      depositController.pickImage(
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
                          "deposit.imagePicker.camera".trns(),
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
                  GestureDetector(
                    onTap: () {
                      depositController.pickImage(
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
                          "deposit.imagePicker.gallery".trns(),
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
}
