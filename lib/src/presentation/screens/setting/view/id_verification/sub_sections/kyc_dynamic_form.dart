import 'dart:convert';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/id_verification/id_verification_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/id_verification/kyc_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class KycDynamicForm extends StatefulWidget {
  final KycData kycData;

  const KycDynamicForm({super.key, required this.kycData});

  @override
  State<KycDynamicForm> createState() => _KycDynamicFormState();
}

class _KycDynamicFormState extends State<KycDynamicForm> {
  final ThemeController themeController = Get.find<ThemeController>();
  final IdVerificationController idVerificationController = Get.find();
  final Map<String, TextEditingController> textControllers = {};

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> parsedFields = jsonDecode(
      widget.kycData.fields!,
    );
    parsedFields.forEach((key, field) {
      if (field['type'] == 'text' || field['type'] == 'textarea') {
        textControllers[field['name']] = TextEditingController();
      }
    });
  }

  @override
  void dispose() {
    textControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> parsedFields = jsonDecode(
      widget.kycData.fields!,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
        idVerificationController.selectedImages.clear();
        idVerificationController.formData.clear();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CommonAppBar(
                    padding: 0,
                    title: widget.kycData.name!,
                    isPopEnabled: false,
                    showRightSideIcon: false,
                    isUtilsBackLogic: true,
                    backLogicFunction: () {
                      Get.find<NavigationController>().popPage();
                      idVerificationController.selectedImages.clear();
                      idVerificationController.formData.clear();
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
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
                                      idVerificationController.setFormData(
                                        name,
                                        value,
                                      );
                                      textControllers[name]?.text = value;
                                    },
                                  ),
                                  const SizedBox(height: 20),
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
                                    maxLines: 5,
                                    controller: textControllers[name],
                                    hintText: name,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      idVerificationController.setFormData(
                                        name,
                                        value,
                                      );
                                      textControllers[name]?.text = value;
                                    },
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
                                    showOptions: true,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            } else if (type == 'camera') {
                              return Column(
                                children: [
                                  _buildUploadSection(
                                    title: name,
                                    fieldName: name,
                                    showOptions: false,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 30,
                      top: 20,
                    ),
                    child: CommonElevatedButton(
                      buttonName:
                          "id_verification.kyc_form.submit_button".trns(),
                      onPressed: () {
                        _submitForm();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Visibility(
                visible: idVerificationController.iskycSubmitLoading.value,
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
    required bool showOptions,
  }) {
    return Obx(() {
      final selectedImage = idVerificationController.selectedImages[fieldName];

      return GestureDetector(
        onTap: () {
          if (showOptions) {
            _showImagePickerOptions(fieldName);
          } else {
            idVerificationController.pickImageWithFrontCamera(fieldName);
          }
        },
        child: SizedBox(
          width: double.infinity,
          height: 110,
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
                            showOptions
                                ? PngAssets.commonUploadIcon
                                : PngAssets.cameraCommonIconTwo,
                            width: 18,
                            fit: BoxFit.contain,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextTertiary
                                    : AppColors.textTertiary,
                          ),
                          SizedBox(height: 8),
                          Text(
                            showOptions
                                ? title
                                : "id_verification.kyc_form.tap_to_capture"
                                    .trnsFormat({"title": title}),
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
                          "id_verification.kyc_form.picker.title".trns(),
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
                      idVerificationController.pickImage(
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
                          "id_verification.kyc_form.picker.camera".trns(),
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
                      idVerificationController.pickImage(
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
                          "id_verification.kyc_form.picker.gallery".trns(),
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
      idVerificationController.setFormData(fieldName, controller.text);
    });

    final Map<String, dynamic> parsedFields = jsonDecode(
      widget.kycData.fields!,
    );
    bool isValid = true;

    parsedFields.forEach((key, field) {
      if (field['validation'] == 'required') {
        final fieldName = field['name'];
        if ((field['type'] == 'text' || field['type'] == 'textarea') &&
            (textControllers[fieldName]?.text.isEmpty ?? true)) {
          isValid = false;
          Fluttertoast.showToast(
            msg: "id_verification.kyc_form.validation.required".trnsFormat({
              "field": fieldName,
            }),
            backgroundColor: AppColors.error,
          );
        } else if ((field['type'] == 'file' || field['type'] == 'camera') &&
            !idVerificationController.selectedImages.containsKey(fieldName)) {
          isValid = false;
          Fluttertoast.showToast(
            msg: "id_verification.kyc_form.validation.required".trnsFormat({
              "field": fieldName,
            }),
            backgroundColor: AppColors.error,
          );
        }
      }
    });

    if (isValid) {
      idVerificationController.submitKycForm(widget.kycData.id!);
    }
  }
}
