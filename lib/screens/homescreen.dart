import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/logs_provider.dart';
import 'package:helpmeapp/widgets/appdrawer.dart';
import 'package:provider/provider.dart';

import '../providers/user_data.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<MyUser>(context).getinfo;

    return Scaffold(
      appBar: AppBar(
        title: _user.isloggedin ? Text(_user.name) : Text("Please Log In"),
      ),
      drawer: HomeDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text("HELP ME NOW", style: TextStyle(fontSize: 37)),
          RawMaterialButton(
            fillColor: Colors.red,
            onPressed: () {
              Provider.of<LogsProvider>(context, listen: false).insertlog();
            },
            elevation: 5,
            child: Text(
              "SOS",
              style: TextStyle(fontSize: 45),
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.37),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            shape: CircleBorder(),
          ),
        ]),
      ),
    );
  }
}
