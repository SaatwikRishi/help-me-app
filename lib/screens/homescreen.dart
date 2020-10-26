import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:helpmeapp/widgets/appdrawer.dart';
import 'package:helpmeapp/widgets/streambutton.dart';
import 'package:provider/provider.dart';

import '../providers/user_data.dart';

class HomeScreen extends StatelessWidget {
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
