import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:user_mobile_app/main.dart';

class FirebaseService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> requestPermissionAndInitMessaging() async {
    await requestPermission();
    _initMessaging();
    _initLocalNotification();
  }

  static Future<void> requestPermission() async {
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

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<String> getToken() async {
    String token = await FirebaseMessaging.instance.getToken() ?? '';
    print('Token: $token');
    return token;
  }

  static void _initMessaging() {
    _onMessage();
    _onMessageOpenedApp();
    _onBackgroundMessage();
    _onInitialMessage();
  }

  static void _onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print("title of message: ${message.notification!.title}");
        print("chat screen value : $chatScreen");
        if (message.notification?.title == "New Message" && chatScreen){
           print('Message also contained a notification: 3232');
          return;
        }else{
           print('Message also contained a notification: 3232');

        _showNotification(
          message.notification?.title ?? '',
          message.notification?.body ?? '',
        );
        }
      }
    });
  }

  static void _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });
  }

  static void _onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    print("title of message: ${message.notification!.title}");
    print("chat screen value : $chatScreen");

    if (message.notification?.title == "New Message" && chatScreen){
      return;
    }else{

    _showNotification(
      message.notification?.title ?? '',
      message.notification?.body ?? '',
    );
    }
    print('Message data: ${message.data}');
  }

  static void _onInitialMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('A new onMessageOpenedApp event was published!');
        print('Message data: ${message.data}');
      }
    });
  }

  static Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }


  static Future<void> _showNotification(
      String title, String body) async {
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
      );
    } catch (e) {
      print(e);
    }
  }
}
