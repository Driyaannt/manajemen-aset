import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manajemen_aset/splashscreen.dart';
// import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // NotificationService().init;
  requestPermission();
  FirebaseMessaging.onBackgroundMessage(_handleBGNotification);
  await FirebaseMessaging.instance.subscribeToTopic('live-data');
  // await Upgrader.clearSavedSettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'live_data_channel', // id
      'live-data', // title
      description: 'Notifikasi untuk data terputus', // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    // _checkStatus();

    // timer = Timer.periodic(
    //   const Duration(minutes: 3),
    //   (timer) {
    //     _checkStatus();
    //   },
    // );

    // ketika notifikasi di klik dan keadaaanya on terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint(message.notification!.title);
      }
    });

    // ketika notifikasi di klik dan keadaanya on background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});

    // ketika on foreground
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // ada notif masuk
        debugPrint('ada notif');
        debugPrint(message.notification!.title);
        debugPrint(message.notification!.body);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
      FlutterAppBadger.updateBadgeCount(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F3F1),
        primarySwatch: Colors.teal,
        colorScheme: const ColorScheme.light(primary: Color(0xFF129575)),
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        primaryColor: const Color(0xFF129575),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF129575),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color.fromARGB(225, 243, 241, 241),
          iconTheme: IconThemeData(color: Colors.black87),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // <-- SEE HERE
            statusBarIconBrightness:
                Brightness.dark, //<-- For Android SEE HERE (dark icons)
            statusBarBrightness:
                Brightness.light, //<-- For iOS SEE HERE (dark icons)
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      // home: UpgradeAlert(
      //   upgrader: Upgrader(
      //     durationUntilAlertAgain: const Duration(hours: 1),
      //     showIgnore: false,
      //     showLater: false,
      //   ),
      //   child: const SplashScreen(),
      // ),
    );
  }
}

// Future<void> _checkStatus() async {
//   Uri url = Uri.parse("http://ebt-polinema.site/api/notif/livedata-status");
//   var response = await http.post(
//     url,
//     body: {"ws_id": "1", "wt_id": "1", "sp_id": "1"},
//   );

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     final bool wsStatus = data['ws']['status'];
//     final bool wtStatus = data['wt']['status'];
//     final bool spStatus = data['sp']['status'];
//     final String wsMsg = data['ws']['msg'];
//     final String wtMsg = data['wt']['msg'];
//     final String spMsg = data['sp']['msg'];

//     if (wsStatus == true) {
//       _sendNotif(wsMsg);
//     }
//     if (wtStatus == true) {
//       _sendNotif(wtMsg);
//     }
//     if (spStatus == true) {
//       _sendNotif(spMsg);
//     }
//   } else {
//     throw Exception('Failed to fetch data');
//   }
// }

// Future<void> _sendNotif(String msg) async {
//   Uri url = Uri.parse(
//       "https://fcm.googleapis.com/v1/projects/skripsi-c0717/messages:send");
//   String body = json.encode({
//     "message": {
//       "topic": "live-data",
//       "notification": {
//         "title": "Data Terputus",
//         "body": msg,
//       }
//     }
//   });
//   var response = await http.post(
//     url,
//     headers: {"Authorization": "Bearer ", "Content-Type": "application/json"},
//     body: body,
//   );
//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception('Failed to load notification');
//   }
// }

// fungsi untuk meng handle background notifikasi
Future<void> _handleBGNotification(RemoteMessage message) async {
  debugPrint(message.notification!.title);
  FlutterAppBadger.updateBadgeCount(1);
}

Future<void> requestPermission() async {
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
    debugPrint('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint('User granted provisional permission');
  } else {
    debugPrint('User declined or has not accepted permission');
  }
}
