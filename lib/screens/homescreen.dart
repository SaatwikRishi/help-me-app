import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:helpmeapp/screens/mapstream.dart';

import 'package:helpmeapp/widgets/appdrawer.dart';
import 'package:helpmeapp/widgets/streambutton.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool transfer = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HOME")),
      drawer: HomeDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text("HELP ME NOW", style: TextStyle(fontSize: 37)),
          StreamButton(),
        ]),
      ),
    );
  }
}
