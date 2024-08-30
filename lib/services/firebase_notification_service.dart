import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:get_storage/get_storage.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  log("message received ${message.notification!.title}");
}

class NotificationService {
  static Future<void> initialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? fcmtoken = await FirebaseMessaging.instance.getToken();
      if (fcmtoken != null) {
        GetStorage().write('fcm', fcmtoken);
        log("FCM token is -----${GetStorage().read('fcm')}");
        log(fcmtoken);
      }
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);

      log("notificatin initialized!");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }
}
