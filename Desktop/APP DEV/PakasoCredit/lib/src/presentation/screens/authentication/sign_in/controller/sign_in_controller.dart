import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/model/user_model.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final NetworkService _networkService = Get.find<NetworkService>();
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = true.obs;
  final RxBool isBiometricEnable = false.obs;
  final emailOrUsernameController = TextEditingController();
  final passwordController = TextEditingController();
  final Rx<UserModel> userModel = UserModel().obs;
  final RxString accountCreation = "".obs;
  final RxString biometricEmail = "".obs;
  final RxString biometricPassword = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    biometricEmail.value = await SettingsService.getLoggedInUserEmail() ?? '';
    biometricPassword.value = await SettingsService.getLoggedInUserPassword() ?? '';
    isBiometricEnable.value = await SettingsService.getBiometricEnableOrDisable() ?? false;
  }

  Future<void> submitSignIn({bool useBiometric = false}) async {
    isLoading.value = true;
    final String email = useBiometric ? biometricEmail.value.trim() : emailOrUsernameController.text.trim();
    final String password = useBiometric ? biometricPassword.value.trim() : passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      isLoading.value = false;
      _showToast("Please enter your credentials", AppColors.error);
      return;
    }

    try {
      final response = await _networkService.login(
        email: email,
        password: password,
      );

      if (response.status == Status.completed) {
        await Get.find<SettingsService>().saveLoggedInUserEmail(email);
        await Get.find<SettingsService>().saveLoggedInUserPassword(password);
        try {
          await postFcmNotification();
        } catch (_) {}
        await fetchUser(email: email, password: password);
      } else {
        _showToast(response.message ?? "Login failed", AppColors.error);
      }
    } catch (e) {
      _showToast("An error occurred during sign in.", AppColors.error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUser({required String email, required String password}) async {
    try {
      final response = await _networkService.get(endpoint: ApiPath.userEndpoint);
      if (response.status == Status.completed && response.data != null) {
        
        // --- RESILIENT UNWRAPPING ---
        // ViserLab APIs often wrap data: { "data": { "user": { ... } } }
        var rawData = response.data!;
        Map<String, dynamic> userMap = rawData;
        
        if (rawData.containsKey('data') && rawData['data'] is Map) {
          final nestedData = rawData['data'] as Map<String, dynamic>;
          if (nestedData.containsKey('user') && nestedData['user'] is Map) {
            userMap = nestedData['user'] as Map<String, dynamic>;
          } else {
            userMap = nestedData;
          }
        }

        userModel.value = UserModel.fromJson(userMap);

        if (userModel.value.twoFa == true) {
          Get.toNamed(BaseRoute.twoFa, arguments: {"email": email});
        } else {
          // Save credentials for biometric login on next launch
          await Get.find<SettingsService>().saveLoggedInUserEmail(email);
          await Get.find<SettingsService>().saveLoggedInUserPassword(password);
          await Get.find<SettingsService>().saveBiometricEnableOrDisable(true);
          biometricEmail.value = email;
          biometricPassword.value = password;
          isBiometricEnable.value = true;
          Get.offAllNamed(BaseRoute.navigation);
          _showToast("Welcome back!", AppColors.success);
        }
        resetFields();
      }
    } catch (e) {
      debugPrint("Fetch User Error: $e");
      _showToast("Error processing user data. Please contact support.", AppColors.error);
    }
  }

  Future<void> postFcmNotification() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final savedFcmToken = await SettingsService.getFcmToken();
    String deviceId = 'unknown';
    String deviceType = Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'unknown');

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown';
      }
    } catch (_) {}

    await _networkService.globalPost(
      endpoint: ApiPath.getSetupFcm,
      data: {
        'device_id': deviceId,
        'device_type': deviceType,
        'fcm_token': savedFcmToken ?? '',
      },
    );
  }

  void resetFields() {
    emailOrUsernameController.clear();
    passwordController.clear();
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(msg: message, backgroundColor: backgroundColor, toastLength: Toast.LENGTH_LONG);
  }
}
