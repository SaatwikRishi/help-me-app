import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/friends_provider.dart';

import 'package:helpmeapp/widgets/searchbar.dart';
import 'package:provider/provider.dart';

import '../providers/user_data.dart';

class AddFriend extends StatelessWidget {
  List<Contacts> _temp = [];
  bool _searching = false;

  final TextEditingController _controller = new TextEditingController();

  void searchdata(String search, BuildContext ctx) {
    _searching = true;
    Provider.of<FriendsProvider>(ctx, listen: false).rebuild;
    FriendsProvider.databasesearch(search).then((value) {
      _temp = value;
      _searching = false;
    }).then(
        (value) => Provider.of<FriendsProvider>(ctx, listen: false).rebuild);
  }

  @override
  Widget build(BuildContext context) {
    final _i = Provider.of<MyUser>(context, listen: false);
    final Uinfo myinfo = _i.info;
    final _l = Provider.of<FriendsProvider>(context);
    print(_temp.length);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Friends and Family'),
        ),
        body: Column(
          children: [
            SearchBar(searchdata, _controller),
            Expanded(
                child: _controller.text.length == 0
                    ? Center(
                        child:
                            Text("Looks like you haven't searched for anyone"),
                      )
                    : _temp.length == 0 || _searching
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemBuilder: (ctx, i) => Card(
                                  child: ListTile(
                                    leading: Text(_temp[i].name),
                                    trailing: IconButton(
                                        icon:
                                            myinfo.friends.contains(_temp[i].id)
                                                ? Icon(Icons.remove)
                                                : Icon(Icons.add),
                                        onPressed: () {
                                          _searching = true;
                                          _l.rebuild;
                                          if (myinfo.friends
                                              .contains(_temp[i].id)) {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .update({
                                                  'friends':
                                                      FieldValue.arrayRemove(
                                                          [_temp[i].id])
                                                })
                                                .then((value) =>
                                                    _i.getinfo(refresh: true))
                                                .then((value) =>
                                                    _searching = false)
                                                .then((value) => _l.rebuild);
                                          } else {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .update({
                                                  'friends':
                                                      FieldValue.arrayUnion(
                                                          [_temp[i].id])
                                                })
                                                .then((value) =>
                                                    _i.getinfo(refresh: true))
                                                .then((value) =>
                                                    _searching = false)
                                                .then((value) => _l.rebuild);
                                          }
                                        }),
                                  ),
                                ),
                            itemCount: _temp.length))
          ],
        ));
  }
}
