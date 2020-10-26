import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Contacts {
  final String avatar;
  final String id;
  final String name;
  final String type;
  final String phone;
  final String email;

  Contacts(
      {this.id, this.avatar, this.name, this.type, this.phone, this.email});
}

class FriendsProvider with ChangeNotifier {
  void get rebuild {
    notifyListeners();
  }

  static Future<List<Contacts>> databasesearch(String name) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('name', isLessThanOrEqualTo: name)
        .get()
        .then((value) {
      List<Contacts> _searchContacts = [];

      value.docs.forEach((element) {
        print(element.data());

        Map<dynamic, dynamic> _ele = element.data();
        _searchContacts.add(Contacts(
            id: _ele['uid'], name: _ele['name'], email: _ele['email']));
      });

      return _searchContacts;
    });
  }

  List<Contacts> get contacts {
    return [..._contacts];
  }

  List<Contacts> _contacts = [];

  Future<List<Contacts>> getcontacts(List<dynamic> _cs,
      {bool refresh = false}) {
    if (_contacts.length == 0 || refresh)
      return FirebaseFirestore.instance
          .collection('users')
          .where('uid', whereIn: _cs)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          final _ele = element.data();
          print(_ele);
          _contacts.add(Contacts(
              id: _ele['uid'], name: _ele['name'], email: _ele['email']));
        });
        return Future.delayed(Duration(microseconds: 0))
            .then((value) => _contacts);
      });
    return Future.delayed(Duration(microseconds: 0)).then((value) => _contacts);
  }
}
