import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/friends_provider.dart';
import 'package:helpmeapp/providers/logs_provider.dart';
import 'package:helpmeapp/providers/user_data.dart';
import 'package:helpmeapp/screens/homescreen.dart';

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
        routes: {ViewFriend.routeName: (ctx) => ViewFriend()},
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snap) => snap.hasData ? HomeScreen() : AuthScreen());
  }
}
