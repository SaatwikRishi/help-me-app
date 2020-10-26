import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/friends_provider.dart';

import 'package:helpmeapp/widgets/locallist.dart';

import 'package:provider/provider.dart';

import '../providers/user_data.dart';
import '../providers/user_data.dart';
import '../widgets/locallist.dart';

class ViewFriend extends StatelessWidget {
  static const routeName = '/viewfriend';
  @override
  Widget build(BuildContext context) {
    final Uinfo _user = Provider.of<MyUser>(context).info;

    return Scaffold(
      appBar: AppBar(
        title: Text('View Friends and Family'),
      ),
      body: Container(
          child: RefreshIndicator(
        onRefresh: () => Provider.of<FriendsProvider>(context, listen: false)
            .getcontacts(_user.friends, refresh: true),
        child: Column(children: [
          FutureBuilder(
              builder: (ctx, snap) {
                final List<Contacts> _l = snap.data;
                if (snap.hasData) {
                  return LocalList(_l);
                }
                if (snap.hasError) {
                  return Center(
                    child: Text("An Error Occoured"),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: Provider.of<FriendsProvider>(context, listen: false)
                  .getcontacts(_user.friends))
        ]),
      )),
    );
  }
}
