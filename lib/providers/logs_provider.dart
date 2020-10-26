import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Log {
  final LocationData location;

  final DateTime time;
  Log({this.location, this.time});
}

class LogsProvider with ChangeNotifier {
  LocationData _location;
  bool _isactive = false;
  List<Log> _logs = [];
  List<Log> get getlog {
    return [..._logs];
  }

  List<Map<String, dynamic>> setlog() {
    final _prefs = SharedPreferences.getInstance();
    List<Map<String, dynamic>> _temp = [];
    _logs.forEach((element) {
      _temp.add({
        "time": element.time.toIso8601String(),
        "long": element.location.longitude,
        "lat": element.location.latitude
      });
    });
    _prefs.then((value) => value.setString("logs", jsonEncode(_temp)));
  }

  deletelog(int i) {
    _logs.removeAt(i);
    setlog();
  }

  Future<void> retrievelog() async {
    final _prefs = SharedPreferences.getInstance();
    return _prefs.then((value) {
      List<dynamic> _temp = [];
      String _l = value.getString("logs");

      _temp = jsonDecode(_l);
      _logs = [];
      _temp.forEach((element) {
        _logs.add(Log(
            location: LocationData.fromMap(
                {'longitude': element['long'], 'latitude': element['lat']}),
            time: DateTime.parse(element['time'])));
      });
    });
  }

  Future<int> insertlog(DateTime activationtime, DateTime stoptime,
      LocationData startlocation, LocationData endlocation) async {
    return FirebaseFirestore.instance
        .collection('logs')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
          'log': FieldValue.arrayUnion([
            {
              'start_time': activationtime.toIso8601String(),
              'stop_time': stoptime.toIso8601String(),
              'start_location': {
                'long': startlocation.longitude,
                'lat': startlocation.latitude
              },
              'end_location': {
                'long': endlocation.longitude,
                'lat': endlocation.latitude
              },
            }
          ])
        }, SetOptions(merge: true))
        .then((value) => 0)
        .catchError((o) => throw o);

    // final location = Location();
    // location.hasPermission().then((value) async {
    //   if (value == PermissionStatus.granted) {
    //     location.getLocation().then((loc) {});
    //   } else {
    //     location.requestPermission().then((value) {
    //       if (value == PermissionStatus.granted) {
    //         insertlog(isactive: isactive);
    //       } else if (value == PermissionStatus.deniedForever) {
    //         _logs.add(Log(location: null, time: DateTime.now()));
    //       }
    //     });
    //   }
    // }).catchError((e) => print(e));
    //  }
  }
}
