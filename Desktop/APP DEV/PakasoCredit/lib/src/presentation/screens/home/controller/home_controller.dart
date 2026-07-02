import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/languages_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/model/user_model.dart';
import 'package:pakaso_credit/src/common/services/biometric_auth_service.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/home/model/dashboard_model.dart';
import 'package:pakaso_credit/src/presentation/screens/home/model/navigations_model.dart';
import 'package:pakaso_credit/src/utils/helpers/language_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class HomeController extends GetxController {
  final LanguagesController languagesController = Get.put(
    LanguagesController(),
  );
  final RxBool isLoading = false.obs;
  final RxBool isDashboardLoading = false.obs;
  final RxBool isNavigationsLoading = false.obs;
  final RxBool isSettingsLoading = false.obs;
  final RxBool isDeleteAccountLoading = false.obs;
  final RxBool isBiometricEnable = false.obs;
  final RxString language = "".obs;
  final languageController = TextEditingController();
  final reasonController = TextEditingController();
  GlobalKey<ScaffoldState>? _scaffoldKey;
  final RxBool isVisibleBalance = true.obs;
  final Rx<DashboardModel> dashboardModel = DashboardModel().obs;
  final Rx<UserModel> userModel = UserModel().obs;
  final RxList<NavigationsData> navigationsList = <NavigationsData>[].obs;

  final RxString languageSwitcher = "1".obs;
  final RxString multipleCurrency = "1".obs;
  final RxString virtualCard = "1".obs;
  final RxString userDeposit = "1".obs;
  final RxString userDps = "1".obs;
  final RxString userFdr = "1".obs;
  final RxString userLoan = "1".obs;
  final RxString userReward = "1".obs;
  final RxString userPortfolio = "1".obs;
  final RxString userWithdraw = "1".obs;
  final RxString transferStatus = "1".obs;
  final RxString userPayBill = "1".obs;
  final RxString signUpReferral = "1".obs;
  final RxString faVerification = "1".obs;
  final RxString passcodeVerification = "1".obs;
  final RxString kycVerification = "1".obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
    loadBiometricStatus();
  }

  Future<void> loadBiometricStatus() async {
    final savedBiometric = await SettingsService.getBiometricEnableOrDisable();
    isBiometricEnable.value = savedBiometric ?? false;
  }

  Future<void> toggleBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    final biometricAuthService = BiometricAuthService();
    final isSupported = await auth.isDeviceSupported();
    final isAvailable = await biometricAuthService.isBiometricAvailable();

    if (!isSupported) {
      Fluttertoast.showToast(
        msg: "This device does not support biometrics.",
        backgroundColor: AppColors.error,
      );
      return;
    }
    if (!isAvailable) {
      _showBiometricNotAvailableDialog();
      return;
    }

    final isAuthenticated =
        await biometricAuthService.authenticateWithBiometrics();

    if (isAuthenticated) {
      isBiometricEnable.value = !isBiometricEnable.value;
      await Get.find<SettingsService>().saveBiometricEnableOrDisable(
        isBiometricEnable.value,
      );

      Fluttertoast.showToast(
        msg:
            isBiometricEnable.value
                ? "Biometric enabled successfully"
                : "Biometric disabled successfully",
        backgroundColor: AppColors.success,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Authentication failed. Biometric setting not changed.",
        backgroundColor: AppColors.error,
      );
    }
  }

  Future<void> loadData() async {
    isLoading.value = true;
    isDashboardLoading.value = true;
    
    try {
      languageSwitcher.value = await SettingsService.getSettingValue('language_switcher') ?? "1";
      multipleCurrency.value = await SettingsService.getSettingValue('multiple_currency') ?? "1";
      virtualCard.value = await SettingsService.getSettingValue('virtual_card') ?? "1";
      userDeposit.value = await SettingsService.getSettingValue('user_deposit') ?? "1";
      userDps.value = await SettingsService.getSettingValue('user_dps') ?? "1";
      userFdr.value = await SettingsService.getSettingValue('user_fdr') ?? "1";
      userLoan.value = await SettingsService.getSettingValue('user_loan') ?? "1";
      userReward.value = await SettingsService.getSettingValue('user_reward') ?? "1";
      userPortfolio.value = await SettingsService.getSettingValue('user_portfolio') ?? "1";
      userWithdraw.value = await SettingsService.getSettingValue('user_withdraw') ?? "1";
      transferStatus.value = await SettingsService.getSettingValue('transfer_status') ?? "1";
      userPayBill.value = await SettingsService.getSettingValue('user_pay_bill') ?? "1";
      signUpReferral.value = await SettingsService.getSettingValue('sign_up_referral') ?? "1";
      faVerification.value = await SettingsService.getSettingValue('fa_verification') ?? "1";
      passcodeVerification.value = await SettingsService.getSettingValue('passcode_verification') ?? "1";
      kycVerification.value = await SettingsService.getSettingValue('kyc_verification') ?? "1";

      await Future.wait([
        fetchDashboard(),
        fetchUser(),
        fetchNavigations(),
      ]);

      if (languageSwitcher.value != "0") {
        await languagesController.fetchLanguages();
        await _setInitialLanguage();
      }
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
    } finally {
      isDashboardLoading.value = false;
      isLoading.value = false;
    }
  }

  Future<void> _setInitialLanguage() async {
    final savedLocale = await LanguageStorage.getSavedLocale();
    if (savedLocale != null && languagesController.languagesList.isNotEmpty) {
      try {
        final savedLanguage = languagesController.languagesList.firstWhere(
          (lang) => lang.locale == savedLocale,
        );
        language.value = savedLanguage.name!;
        languageController.text = savedLanguage.name!;
        languagesController.locale.value = savedLanguage.locale!;
      } catch (_) {}
    }
  }

  void setScaffoldKey(GlobalKey<ScaffoldState> key) {
    _scaffoldKey = key;
  }

  void openDrawer() {
    _scaffoldKey?.currentState?.openDrawer();
  }

  Future<void> fetchDashboard() async {
    try {
      final response = await Get.find<NetworkService>().get(endpoint: ApiPath.dashboardEndpoint);
      if (response.status == Status.completed && response.data != null) {
        dashboardModel.value = DashboardModel.fromJson(response.data!);
      }
    } catch (e) {
      debugPrint("Fetch Dashboard Error: $e");
    }
  }

  Future<void> fetchUser() async {
    try {
      final response = await Get.find<NetworkService>().get(endpoint: ApiPath.userEndpoint);
      if (response.status == Status.completed && response.data != null) {
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
      }
    } catch (e) {
      debugPrint("Fetch User Error: $e");
    }
  }

  Future<void> fetchNavigations() async {
    try {
      final response = await Get.find<NetworkService>().get(endpoint: ApiPath.getNavigationsEndpoint);
      if (response.status == Status.completed && response.data != null) {
        final model = NavigationsModel.fromJson(response.data!);
        if (model.data != null) {
          navigationsList.assignAll(model.data!);
        }
      }
    } catch (e) {
      debugPrint("Fetch Navigations Error: $e");
    }
  }

  Future<void> submitLogout() async {
    isLoading.value = true;
    try {
      await Get.find<NetworkService>().post(endpoint: ApiPath.logoutEndpoint);
      await Get.find<TokenService>().clearToken();
      Get.offAllNamed(BaseRoute.signIn);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitCloseAccount() async {
    isDeleteAccountLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "reason": reasonController.text,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.profileSettingsEndpoint}/account-close",
        data: requestBody,
      );

      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await submitLogout();
      }
    } finally {
      isDeleteAccountLoading.value = false;
    }
  }

  void toggleVisibleBalance() {
    isVisibleBalance.value = !isVisibleBalance.value;
  }

  void _showBiometricNotAvailableDialog() {
    final ThemeController themeController = Get.find<ThemeController>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        decoration: BoxDecoration(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkSecondary
                  : AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Icon(
              Icons.fingerprint,
              size: 40,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              "Biometric Not Found",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              "No fingerprint or biometric is enrolled on this device. You can set it up from the system settings.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                height: 1.5,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextTertiary
                        : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24.0),
            CommonElevatedButton(
              width: double.infinity,
              buttonName: "Open Security Settings",
              onPressed: _openSecuritySettings,
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  void _openSecuritySettings() {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.SECURITY_SETTINGS',
      );
      intent.launch();
    }
  }
}
