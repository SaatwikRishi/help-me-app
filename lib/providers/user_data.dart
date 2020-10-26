import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Contacts {
  final String avatar;
  final String id;
  final String name;
  final String type;
  final String phone;
  Contacts({this.id, this.avatar, this.name, this.type, this.phone});
}

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
  List<Contacts> get contacts {
    return [..._contacts];
  }

  bool _pending = false;
  Uinfo _info;
  Future<Uinfo> getinfo({bool refresh = false}) {
    if (_info == null) {
      return retrievemyinfo().then((value) => _info);
    }

    return Future.delayed(Duration(microseconds: 0)).then((value) => _info);
  }

  List<Contacts> _contacts = [
    Contacts(
        id: '1',
        avatar: null,
        name: 'John lock',
        type: 'friend',
        phone: '+9199999333'),
    Contacts(
        id: '2',
        avatar: null,
        name: 'Harry Quinn',
        type: 'friend',
        phone: '+99 2343235432'),
    Contacts(
        id: '3',
        avatar: null,
        name: 'Polinski sharma',
        type: 'friend',
        phone: '+91 9834264327'),
    Contacts(
        id: '4',
        avatar: null,
        name: 'Ambika goyal',
        type: 'friend',
        phone: '+91 984321987435'),
    Contacts(
        id: '5',
        avatar: null,
        name: 'Saatwik Rishi',
        type: 'friend',
        phone: '+91 924985643'),
    Contacts(
        id: '6',
        avatar: null,
        name: 'Ambika goyal',
        type: 'friend',
        phone: '+91 984321987435'),
    Contacts(
        id: '7',
        avatar: null,
        name: 'Shashank Sinha',
        type: 'friend',
        phone: '+91 984321987435'),
    Contacts(
        id: '8',
        avatar: null,
        name: 'Gon freeks',
        type: 'friend',
        phone: '+91 984321923425'),
    Contacts(
        id: '9',
        avatar: null,
        name: 'kilua hiraku',
        type: 'friend',
        phone: '+91 945431987435'),
    Contacts(
        id: '10',
        avatar: null,
        name: 'Amol lakun',
        type: 'friend',
        phone: '+91 984321987435'),
  ];

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
