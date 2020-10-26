import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/user_data.dart';
import 'package:helpmeapp/widgets/appdrawer.dart';
import 'package:helpmeapp/widgets/locallist.dart';
import 'package:helpmeapp/widgets/searchbar.dart';
import 'package:provider/provider.dart';

class ViewFriend extends StatelessWidget {
  static const routeName = '/viewfriend';
  @override
  Widget build(BuildContext context) {
    List<Contacts> _users =
        Provider.of<MyUser>(context, listen: false).contacts;
    _users.forEach((element) {
      print(element.id);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('View Friends and Family'),
      ),
      body:
          Container(child: Column(children: [SearchBar(), LocalList(_users)])),
    );
  }
}
