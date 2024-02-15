
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:user_mobile_app/main.dart';

class FirebaseService {
  static Future<String> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print(settings.authorizationStatus);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      return getToken();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      return getToken();
    } else {
      print('User declined or has not accepted permission');
      return '';
    }
  }

  static Future<String> getToken() async {
    String token = await FirebaseMessaging.instance.getToken() ?? '';
    print('Token: $token');
    return token;
    // final userToken = await SecureStorageUtils.getToken() ?? '';
    // if (token.isNotEmpty) {
    //   PushNotificationRepo.saveDeviceToken(
    //       token: token, userToken: userToken ,device: Platform.isAndroid ? 'ANDROID' : 'IOS');
    // }
  }

  static void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static void onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });
  }

  static void onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
  }

  static void onInitialMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('A new onMessageOpenedApp event was published!');
        print('Message data: ${message.data}');
      }
    });
  }

  // static void onTokenRefresh() {
  //   FirebaseMessaging.onTokenRefresh.listen((String token) {
  //     print('onTokenRefresh: $token');
  //   });
  // }

  // static void onLocalNotification() {
  //   FirebaseMessaging.onLocalNotificationOpenedApp.listen((RemoteMessage message) {
  //     print('A new onLocalNotification event was published!');
  //     print('Message data: ${message.data}');
  //   });
  // }

  static void onLocalNotificationForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }

    navigatorKey.currentState?.pushNamed('home_screen', arguments: 3);
  }

  Future initialize(BuildContext context) async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      // notificationCountBloc.fetchNotificationCount();
      // NotificationBloc notificationBloc =
      //     BlocProvider.of<NotificationBloc>(context);
      // notificationBloc.add(ResetNotification());
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the background!');
      handleMessage(message);
    });
  }
}