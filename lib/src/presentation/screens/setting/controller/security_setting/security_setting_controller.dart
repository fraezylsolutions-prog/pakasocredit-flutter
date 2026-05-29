import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/model/user_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SecuritySettingController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isGenerateTwoFaLoading = false.obs;
  final RxBool isEnableTwoFaLoading = false.obs;
  final RxBool isDisableTwoFaLoading = false.obs;
  final RxBool isGeneratePasscodeLoading = false.obs;
  final RxBool isChangePasscodeLoading = false.obs;
  final RxBool isDisablePasscodeLoading = false.obs;
  final Rx<UserModel> userModel = UserModel().obs;
  final enable2FaController = TextEditingController();
  final enterPasswordController = TextEditingController();
  final passcodeController = TextEditingController();
  final confirmPasscodeController = TextEditingController();
  final oldPasscodeController = TextEditingController();
  final newPasscodeController = TextEditingController();
  final confirmPasscodeControllerTwo = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> fetchUser() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.userEndpoint,
      );
      if (response.status == Status.completed) {
        userModel.value = UserModel();
        userModel.value = UserModel.fromJson(response.data!);
      } else {
        userModel.value = UserModel();
      }
    } finally {}
  }

  Future<void> submitGenerateTwoFa() async {
    isGenerateTwoFaLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.profileSettingsEndpoint}/2fa/generate",
        data: null,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchUser();
        await Get.find<HomeController>().fetchUser();
      }
    } finally {
      isGenerateTwoFaLoading.value = false;
    }
  }

  Future<void> submitEnableTwoFa() async {
    isEnableTwoFaLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.profileSettingsEndpoint}/2fa/enable",
        data: {"one_time_password": enable2FaController.text},
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        enable2FaController.clear();
        await fetchUser();
        await Get.find<HomeController>().fetchUser();
      }
    } finally {
      isEnableTwoFaLoading.value = false;
    }
  }

  Future<void> submitDisableTwoFa() async {
    isDisableTwoFaLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.profileSettingsEndpoint}/2fa/disable",
        data: {"one_time_password": enterPasswordController.text},
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        enterPasswordController.clear();
        await fetchUser();
        await Get.find<HomeController>().fetchUser();
      }
    } finally {
      isDisableTwoFaLoading.value = false;
    }
  }

  Future<void> submitGeneratePasscode() async {
    isGeneratePasscodeLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.profileSettingsEndpoint}/passcode",
        data: {
          "passcode": passcodeController.text,
          "passcode_confirmation": confirmPasscodeController.text,
        },
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        passcodeController.clear();
        confirmPasscodeController.clear();
        await fetchUser();
        await Get.find<HomeController>().fetchUser();
      }
    } finally {
      isGeneratePasscodeLoading.value = false;
    }
  }

  Future<void> submitChangePasscode() async {
    isChangePasscodeLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.profileSettingsEndpoint}/passcode/change",
        data: {
          "old_passcode": oldPasscodeController.text,
          "passcode": newPasscodeController.text,
          "passcode_confirmation": confirmPasscodeControllerTwo.text,
        },
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        oldPasscodeController.clear();
        newPasscodeController.clear();
        confirmPasscodeControllerTwo.clear();
        await fetchUser();
        await Get.find<HomeController>().fetchUser();
      }
    } finally {
      isChangePasscodeLoading.value = false;
    }
  }

  Future<void> submitDisablePasscode() async {
    isDisablePasscodeLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.profileSettingsEndpoint}/passcode/disable",
        data: {"password": passwordController.text},
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        passwordController.clear();
        await fetchUser();
        await Get.find<HomeController>().fetchUser();
      }
    } finally {
      isDisablePasscodeLoading.value = false;
    }
  }
}
