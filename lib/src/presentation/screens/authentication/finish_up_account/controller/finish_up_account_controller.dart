import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FinishUpAccountController extends GetxController {
  final NetworkService _networkService = Get.find<NetworkService>();
  final RxBool isLoading = false.obs;
  final RxBool isSubmitLoading = false.obs;
  final RxString gender = "".obs;
  final RxString branch = "".obs;
  final RxString branchId = "".obs;
  final RxBool isPasswordVisible = true.obs;
  final RxBool isAgreeChecked = false.obs;
  final genderController = TextEditingController();
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final branchController = TextEditingController();

  Future<void> submitSignUpSecondStep() async {
    isSubmitLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
      };
      if (isAgreeChecked.value == true) {
        requestBody["i_agree"] = 1;
      }
      if (userNameController.text.isNotEmpty) {
        requestBody["username"] = userNameController.text;
      }
      if (genderController.text.isNotEmpty) {
        requestBody["gender"] = gender.value.toLowerCase();
      }
      if (branchController.text.isNotEmpty) {
        requestBody["branch_id"] = branchId.value;
      }

      final response = await Get.find<NetworkService>().registerStepTwo(
        data: requestBody,
      );

      if (response.status == Status.completed) {
        await postFcmNotification();
      }
    } finally {
      isSubmitLoading.value = false;
    }
  }

  Future<void> postFcmNotification() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final savedFcmToken = await SettingsService.getFcmToken();
      String deviceId = '';
      String deviceType = '';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id;
        deviceType = 'android';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
        deviceType = 'ios';
      } else {
        deviceType = 'unknown';
        deviceId = 'unknown';
      }

      final Map<String, String> requestBody = {
        'device_id': deviceId,
        'device_type': deviceType,
        'fcm_token': savedFcmToken ?? '',
      };

      final response = await _networkService.globalPost(
        endpoint: ApiPath.getSetupFcm,
        data: requestBody,
      );

      if (response.status == Status.completed) {
        showToast(response.data!["message"], AppColors.success);
        resetFields();
        Get.offAllNamed(BaseRoute.congrats);
      }
    } finally {}
  }

  @override
  void onClose() {
    super.onClose();
    genderController.dispose();
    userNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    branchController.dispose();
  }

  void resetFields() {
    gender.value = "";
    branch.value = "";
    branchId.value = "";
    genderController.clear();
    userNameController.clear();
    firstNameController.clear();
    lastNameController.clear();
    branchController.clear();
  }

  void showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
