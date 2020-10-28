import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/friends_provider.dart';
import 'package:helpmeapp/providers/item.dart';
import 'package:helpmeapp/providers/logs_provider.dart';

import 'package:helpmeapp/providers/user_data.dart';
import 'package:helpmeapp/screens/homescreen.dart';
import 'package:helpmeapp/screens/mapstream.dart';

import 'package:helpmeapp/screens/viewfriend.dart';
import 'package:provider/provider.dart';

import 'screens/homescreen.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MyUser()),
        ChangeNotifierProvider.value(value: LogsProvider()),
        ChangeNotifierProvider.value(value: FriendsProvider()),
      ],
      child: MaterialApp(
        title: 'Help Me App',
        theme: ThemeData.dark(),
        home: MyHomePage(),
        routes: {
          ViewFriend.routeName: (ctx) => ViewFriend(),
          // MapStream.routename: (ctx) => MapStream()
        },
      ),
    );
  }
}

Future<dynamic> onbackgroundmessagehandler(Map<String, dynamic> message) {
  print("BACKGROUND");
  print(message);
}

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, MessageBean> _items = <String, MessageBean>{};
  MessageBean _itemForMessage(Map<String, dynamic> message) {
    //If the message['data'] is non-null, we will return its value, else return map message object
    print("message");
    final dynamic data = message['data'] ?? message;

    final String itemId = data['uid'];

    final MessageBean item =
        _items.putIfAbsent(itemId, () => MessageBean(itemId: itemId));

    return item;
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final MessageBean item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }

  void _initfbm() {
    final GlobalKey<NavigatorState> navigatorKey =
        GlobalKey(debugLabel: "Main Navigator");
    final _fbm = FirebaseMessaging();

    _fbm.requestNotificationPermissions();

    Future.delayed(Duration(seconds: 1)).then((value) {
      _fbm.configure(
        onResume: (message) async {
          return _navigateToItemDetail(message);
        },
        onBackgroundMessage: onbackgroundmessagehandler,
        onLaunch: (message) async {
          _navigateToItemDetail(message);
          return;
        },
        onMessage: (msg) async {
          print("ON MSG");
          print("onMessage: $msg");

          return _navigateToItemDetail(msg);
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _initfbm();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snap) => snap.hasData ? HomeScreen() : AuthScreen());
  }
}
