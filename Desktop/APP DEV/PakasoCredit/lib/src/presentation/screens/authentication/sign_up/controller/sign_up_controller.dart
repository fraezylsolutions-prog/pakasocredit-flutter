import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSubmitLoading = false.obs;
  final RxString country = "".obs;
  final RxString countryCode = "".obs;
  final RxString countryDialCode = "".obs;
  final RxBool isPasswordVisible = true.obs;
  final countryController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final referralCodeController = TextEditingController();
  final RxMap<String, dynamic> customFields = <String, dynamic>{}.obs;
  final RxMap<String, TextEditingController> customFieldControllers =
      <String, TextEditingController>{}.obs;

  Future<void> submitSignUpFirstStep() async {
    isSubmitLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      if (referralCodeController.text.isNotEmpty) {
        requestBody["invite"] = referralCodeController.text;
      }

      if (countryController.text.isNotEmpty) {
        requestBody["country"] = countryCode.value;
      }

      if (phoneController.text.isNotEmpty) {
        requestBody["phone"] = "$countryDialCode${phoneController.text}";
      }

      if (customFields.isNotEmpty) {
        Map<String, String> customFieldsData = {};

        for (String key in customFields.keys) {
          final controller = customFieldControllers[key];
          if (controller != null && controller.text.isNotEmpty) {
            customFieldsData[customFields[key]['name']!] = controller.text;
          }
        }

        if (customFieldsData.isNotEmpty) {
          requestBody["custom_fields_data"] = customFieldsData;
        }
      }

      final response = await Get.find<NetworkService>().registerStepOne(
        data: requestBody,
      );

      if (response.status == Status.completed) {
        await Get.find<SettingsService>().saveLoggedInUserEmail(
          emailController.text,
        );
        await Get.find<SettingsService>().saveLoggedInUserPassword(
          passwordController.text,
        );
        Get.offNamed(BaseRoute.finishUpAccount);
        showToast(response.data!["message"], AppColors.success);
        resetFields();
      }
    } finally {
      isSubmitLoading.value = false;
    }
  }

  Map<String, String> getCustomFieldValues() {
    Map<String, String> customFieldValues = {};
    for (String key in customFieldControllers.keys) {
      final controller = customFieldControllers[key];
      if (controller != null && controller.text.isNotEmpty) {
        customFieldValues[key] = controller.text;
      }
    }
    return customFieldValues;
  }

  void resetFields() {
    country.value = "";
    countryCode.value = "";
    countryDialCode.value = "";
    countryController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    referralCodeController.clear();
  }

  void showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  void onClose() {
    super.onClose();
    countryController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    referralCodeController.dispose();
  }
}
