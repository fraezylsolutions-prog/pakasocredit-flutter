import 'dart:convert';

import 'package:pakaso_credit/src/common/model/settings_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends GetxService {
  static const String currencySymbolKey = 'currency_symbol';
  static const String currentEmailKey = 'current_email';
  static const String currentPasswordKey = 'current_password';
  static const String currentBiometricKey = 'current_biometric';
  static const String currentFcmTokenKey = 'current_fcm_token';
  static const _key = 'app_settings';

  final Rx<String?> currencySymbol = Rx<String?>(null);
  final Rx<String?> currentEmail = Rx<String?>(null);
  final Rx<String?> currentPassword = Rx<String?>(null);
  final Rx<bool?> currentBiometric = Rx<bool?>(null);
  final Rx<String?> currentFcmToken = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCurrencySymbol();
  }

  Future<void> loadCurrencySymbol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currencySymbol.value = prefs.getString(currencySymbolKey);
  }

  Future<bool> saveCurrencySymbol(String symbol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currencySymbol.value = symbol;
    return await prefs.setString(currencySymbolKey, symbol);
  }

  static Future<void> saveSettings(List<SettingsModel> settings) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(settings.map((s) => s.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<List<SettingsModel>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonStr);
    return decoded.map((item) => SettingsModel.fromJson(item)).toList();
  }

  static Future<String?> getSettingValue(String key) async {
    final settings = await loadSettings();
    return settings.firstWhere((s) => s.name == key).value;
  }

  Future<bool> saveLoggedInUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentEmail.value = email;
    return await prefs.setString(currentEmailKey, email);
  }

  Future<bool> saveLoggedInUserPassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentPassword.value = password;
    return await prefs.setString(currentPasswordKey, password);
  }

  Future<bool> saveFcmToken(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentFcmToken.value = fcmToken;
    return await prefs.setString(currentFcmTokenKey, fcmToken);
  }

  Future<bool> saveBiometricEnableOrDisable(bool biometric) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentBiometric.value = biometric;
    return await prefs.setBool(currentBiometricKey, biometric);
  }

  static Future<String?> getLoggedInUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentEmailKey);
  }

  static Future<String?> getLoggedInUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentPasswordKey);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentFcmTokenKey);
  }

  static Future<bool?> getBiometricEnableOrDisable() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(currentBiometricKey);
  }

  Future<void> fetchSettings() async {
    try {
      final response = await Get.find<NetworkService>().globalGet(
        endpoint: ApiPath.getSettingsEndpoint,
      );
      if (response.status == Status.completed) {
        List<dynamic> data = response.data!['data'];
        List<SettingsModel> settings =
            data.map((item) => SettingsModel.fromJson(item)).toList();
        await SettingsService.saveSettings(settings);
      }
    } finally {}
  }
}
