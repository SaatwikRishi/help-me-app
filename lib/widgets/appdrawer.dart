import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/demo_login.dart';
import 'package:helpmeapp/screens/addfriend.dart';
import 'package:helpmeapp/screens/logs.dart';
import 'package:helpmeapp/screens/viewfriend.dart';
import 'package:helpmeapp/screens/login.dart';
import 'package:provider/provider.dart';

import '../providers/user_data.dart';

class HomeDrawer extends StatelessWidget {
  final isloggedin = FirebaseAuth.instance.currentUser == null ? false : true;
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<MyUser>(context).getinfo;
    return Drawer(
      elevation: 5,
      child: ListView(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            color: Colors.blue,
            height: isloggedin ? MediaQuery.of(context).size.height * 0.3 : 0,
            child: Card(
              child: isloggedin
                  ? null
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            _user.name,
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                        Expanded(child: Text(DemoLogin.email)),
                      ],
                    ),
            ),
          ),
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
