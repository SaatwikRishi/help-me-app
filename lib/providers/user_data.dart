import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Uinfo {
  String name;
  String email;
  List<dynamic> friends;
  String phone;
  String address;
  Uinfo({
    this.email,
    this.name,
    this.address,
    this.friends,
    this.phone,
  });
}

class MyUser extends ChangeNotifier {
  Uinfo _info;
  Uinfo get info {
    return _info;
  }

  Future<Uinfo> getinfo({bool refresh = false}) {
    if (_info == null || refresh) {
      return retrievemyinfo().then((value) => _info);
    }

    return Future.delayed(Duration(microseconds: 0)).then((value) => _info);
  }

  Future<Uinfo> retrievemyinfo() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      final Map<dynamic, dynamic> _data = value.data();
      _info = Uinfo(
          name: _data['name'],
          address: null,
          email: _data['email'],
          friends: _data['friends'],
          phone: null);

      return _info;
    }).catchError((e) => throw e);
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
