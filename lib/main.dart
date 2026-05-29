import 'package:pakaso_credit/firebase_options.dart';
import 'package:pakaso_credit/src/app/app.dart';
import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/services/fcm_service.dart';
import 'package:pakaso_credit/src/common/services/notification_service.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/common/services/translation_service.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/utils/helpers/language_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await NotificationService.showFromRemoteMessage(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await _initializeServices();

  _configureUI();

  runApp(const PakasoCreditApp());
}

Future<void> _initializeServices() async {
  await NotificationService.initialize();

  final settingsService = Get.put(SettingsService());

  await FCMService.initFCM();

  Get.put(ThemeController());

  Get.put<TokenService>(TokenService());

  Get.put(NetworkService());

  await _initializeTranslations();

  await settingsService.fetchSettings();
}

Future<void> _initializeTranslations() async {
  final translationService = Get.put(TranslationService());
  final savedLocale = await LanguageStorage.getSavedLocale();
  final locale = savedLocale ?? 'en';
  await translationService.loadTranslations(locale);
}

void _configureUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
