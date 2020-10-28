import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:helpmeapp/screens/addfriend.dart';
import 'package:helpmeapp/screens/logs.dart';
import 'package:helpmeapp/screens/mapstream.dart';
import 'package:helpmeapp/screens/viewfriend.dart';
import 'package:helpmeapp/screens/login.dart';
import 'package:provider/provider.dart';

import '../providers/user_data.dart';

class HomeDrawer extends StatelessWidget {
  final isloggedin = FirebaseAuth.instance.currentUser == null ? false : true;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: ListView(
        children: [
          Container(
              color: Colors.blue,
              height: isloggedin ? MediaQuery.of(context).size.height * 0.3 : 0,
              child: Card(
                  child: !isloggedin
                      ? null
                      : FutureBuilder(
                          future: Provider.of<MyUser>(context, listen: false)
                              .getinfo(),
                          builder: (context, snap) {
                            final Uinfo _user = snap.data;
                            if (snap.hasError)
                              return Center(
                                child: Text("AN ERROR OCCOURED"),
                              );
                            if (snap.hasData)
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _user.name,
                                      style: TextStyle(fontSize: 40),
                                    ),
                                  ),
                                  Expanded(child: Text(_user.email)),
                                ],
                              );
                            return Center(child: CircularProgressIndicator());
                          }))),
          Divider(),
          ListTile(
              leading: Icon(Icons.people),
              title: Text('Add Friends And Family'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddFriend()));
              }),
          Divider(),
          ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text('View Friends and Family'),
              onTap: () {
                Navigator.of(context).pushNamed(ViewFriend.routeName);
              }),
          ListTile(
              leading: Icon(Icons.map),
              title: Text('Map Stream'),
              onTap: () {
                //  Navigator.of(context).pushNamed(MapStream.routename);
              }),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => LogsScreen()));
            },
            leading: Icon(Icons.description),
            title: Text('View Logs'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Change Settings'),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.local_parking),
              title: isloggedin ? Text('Logout') : const Text("Login"),
              onTap: () {
                if (isloggedin) {
                  Provider.of<MyUser>(context, listen: false).logout();
                } else
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AuthScreen()));
              }),
        ],
      ),
    );
  }
}
