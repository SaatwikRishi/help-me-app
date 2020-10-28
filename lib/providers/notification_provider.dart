import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> onSelect(String data) async {
  print("onSelectNotification $data");
}

//updated myBackgroundMessageHandler
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("myBackgroundMessageHandler message: $message");
  // int msgId = int.tryParse(message["data"]["msgId"].toString()) ?? 0;

  // var androidPlatformChannelSpecifics =
  // AndroidNotificationDetails(
  //     'your channel id', 'your channel name',
  //     'your channel description', color: Colors.blue.shade800,
  //     importance: Importance.Max,
  //     priority: Priority.High, ticker: 'ticker');
  // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  // var platformChannelSpecifics = NotificationDetails(
  //     androidPlatformChannelSpecifics,
  //     iOSPlatformChannelSpecifics);
  // flutterLocalNotificationsPlugin
  //     .show(msgId,
  //     message["data"]["msgTitle"],
  //     message["data"]["msgBody"], platformChannelSpecifics,
  //     payload: message["data"]["data"]);
  return Future<void>.value();
}

class PushNotificationsManager {
  PushNotificationsManager._();
  static Future<dynamic> bckmh(Map<String, dynamic> _msg) {
    print("ffF");
    print(_msg);
  }

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  static void initfbm() {
    final _fbm = FirebaseMessaging();
    _fbm.requestNotificationPermissions();
    _fbm.configure(
      onLaunch: (message) {
        //  Navigator.of(context).pushNamed(MapStream.routename);
        return;
      },
      onMessage: (msg) {
        print(msg);
        return;
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );
  }

  // Future<void> init() async {
  //   if (!_initialized) {
  //     // For iOS request permission first.
  //     _firebaseMessaging.requestNotificationPermissions();
  //     _firebaseMessaging.configure(
  //       onBackgroundMessage: (messge) {
  //         print("FFF");
  //         print(messge);
  //       },
  //       onMessage: (message) {
  //         print("FFF");
  //         print(message);
  //       },
  //     );

  //     // For testing purposes print the Firebase Messaging token

  //     _initialized = true;
  //   }
  // }
}
