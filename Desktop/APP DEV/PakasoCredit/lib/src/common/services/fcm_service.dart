import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FCMService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription =
      'This channel is used for important notifications.';

  static Future<void> initFCM() async {
    await _requestPermission();
    await _saveTokenToService();
    _setupMessageHandlers();
  }

  static Future<void> _requestPermission() async {
    // Request Android 13+ notification permission
    if (GetPlatform.isAndroid) {
      final plugin = FlutterLocalNotificationsPlugin();
      final androidPlugin = plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }

    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('User denied notification permissions');
    }
  }

  static Future<void> _saveTokenToService() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null && Get.isRegistered<SettingsService>()) {
        await Get.find<SettingsService>().saveFcmToken(token);
      }
    } finally {}
  }

  static void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      await showLocalNotification(
        title: message.notification!.title ?? 'No Title',
        body: message.notification!.body ?? 'No Body',
        data: message.data,
      );
    }
  }

  static Future<void> _handleNotificationTap(RemoteMessage message) async {}

  static Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
    int id = 0,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
        payload: data?.toString(),
      );
    } finally {}
  }

  static Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } finally {}
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } finally {}
  }
}
