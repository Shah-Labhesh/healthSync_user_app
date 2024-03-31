import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<String> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

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
  }

  static void initMessaging() {
    onMessage();
    onMessageOpenedApp();
    onBackgroundMessage();
    onInitialMessage();
  }

  static void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        showNotification(message.notification?.title ?? '',
            message.notification?.body ?? '', '');
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

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    showNotification(message.notification?.title ?? '',
        message.notification?.body ?? '', '');
    print('Message data: ${message.data}');
  }

  static void onInitialMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('A new onMessageOpenedApp event was published!');
        print('Message data: ${message.data}');
      }
    });
  }

  static Future<void> initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (details) {
        print('onDidReceiveBackgroundNotification: $details');
        
      },
      onDidReceiveNotificationResponse: (details) {
        print('onDidReceiveNotification: $details');
      },
    );
  }

  static Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      print('Notification payload: $payload');
    }
  }

  static Future<void> showNotification(
      String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '32323e2',
      'Your channel name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
   try {
      const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
   } catch (e) {
     print(e);
   }
  }
}
