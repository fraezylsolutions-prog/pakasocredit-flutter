import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmPasscodeController extends GetxController {
  final RxString passcodeStatus = "".obs;
  final passcodeController = TextEditingController();

  Future<void> loadPasscodeStatus({required String passcodeType}) async {
    final passcodeTypeValue = await SettingsService.getSettingValue(
      passcodeType,
    );
    passcodeStatus.value = passcodeTypeValue ?? "";
  }

  Future<bool> submitPasscodeVerify() async {
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.profileSettingsEndpoint}/passcode/verify",
        data: {"passcode": passcodeController.text},
      );
      if (response.status == Status.completed) {
        passcodeController.clear();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
