// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   //instance of FlutterLocalNotificationsPlugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     //Initialization Settings for Android
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('mipmap/ic_launcher');

//     //InitializationSettings for initializing settings
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'live_data_channel', // id
//       'live-data', // title
//       description: 'Notifikasi untuk data terputus', // description
//       importance: Importance.max,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   Future<void> showNotifications(RemoteMessage message) async {
//     AndroidNotificationDetails _androidNotificationDetails =
//         const AndroidNotificationDetails(
//       'live-data',
//       'live-data',
//       channelDescription: 'Notifikasi untuk data terputus',
//       playSound: true,
//       priority: Priority.high,
//       importance: Importance.high,
//     );
//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: _androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//       5,
//       message.notification!.title,
//       message.notification!.body,
//       platformChannelSpecifics,
//     );
//   }
// }

// // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //     FlutterLocalNotificationsPlugin();
// // final InitializationSettings initializationSettings = InitializationSettings();
// // class NotificationService {
// //   static Future<void> showNotification(RemoteMessage message) async {
// //     AndroidNotificationDetails androidPlatformChannelSpecifics =
// //         const AndroidNotificationDetails(
// //       'live-data',
// //       'live-data',
// //       channelDescription: 'Notifikasi untuk data terputus',
// //       playSound: true,
// //       priority: Priority.high,
// //       importance: Importance.high,
// //     );
// //     NotificationDetails platformChannelSpecifics =
// //         NotificationDetails(android: androidPlatformChannelSpecifics);

// //     await flutterLocalNotificationsPlugin.show(
// //       1,
// //       message.notification!.title,
// //       message.notification!.body,
// //       platformChannelSpecifics,
// //     );
// //   }
// // }
