import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/friends_provider.dart';

class LocalList extends StatelessWidget {
  final List<Contacts> _users;
  LocalList(this._users);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemBuilder: (builder, i) => Card(
          elevation: 5,
          child: ListTile(
            leading: Text(_users[i].name),
            title: Text(_users[i].email),
          ),
        ),
        itemCount: _users.length,
      ),
    );
  }
}
