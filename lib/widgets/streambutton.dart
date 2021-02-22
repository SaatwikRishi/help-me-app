import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:helpmeapp/providers/streambutton_provider.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../providers/logs_provider.dart';

class StreamButton extends StatefulWidget {
  @override
  _StreamButtonState createState() => _StreamButtonState();
}

class _StreamButtonState extends State<StreamButton>
    with WidgetsBindingObserver {
  Geodesy geodesy = Geodesy();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({
        'isactive': false,
        'longitude': StreamLogData.currentlocation.longitude,
        'latitude': StreamLogData.currentlocation.latitude
      }, SetOptions(merge: true));
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return StreamLogData.isactive
        ? RawMaterialButton(
            fillColor: Colors.red,
            onPressed: () {
              StreamLogData.endlocation = StreamLogData.currentlocation;
              StreamLogData.endtime = DateTime.now();
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .set({
                    'isactive': false,
                    'longitude': StreamLogData.currentlocation.longitude,
                    'latitude': StreamLogData.currentlocation.latitude
                  }, SetOptions(merge: true))
                  .then((value) => StreamLogData.isactive = false)
                  .then((value) =>
                      Provider.of<LogsProvider>(context, listen: false)
                          .insertlog(
                              StreamLogData.starttime,
                              StreamLogData.endtime,
                              StreamLogData.startlocation,
                              StreamLogData.endlocation))
                  .then((value) => setState(() {
                        StreamLogData.isactive = false;
                        StreamLogData.currentlocation = null;
                        StreamLogData.startlocation = null;
                        StreamLogData.endlocation = null;
                        StreamLogData.starttime = null;
                        StreamLogData.endtime = null;
                      }));
            },
            elevation: 5,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: StreamBuilder(
                  stream: Location.instance.onLocationChanged,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      if (StreamLogData.currentlocation == null) {
                        StreamLogData.currentlocation = snap.data;
                        StreamLogData.startlocation = snap.data;
                        StreamLogData.starttime = DateTime.now();

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .set({
                          'isactive': true,
                          'longitude': StreamLogData.currentlocation.longitude,
                          'latitude': StreamLogData.currentlocation.latitude
                        }, SetOptions(merge: true));
                      }
                      final LocationData _templocation = snap.data;
                      LatLng p1 = LatLng(
                          _templocation.latitude, _templocation.longitude);
                      LatLng p2 = LatLng(StreamLogData.currentlocation.latitude,
                          StreamLogData.currentlocation.longitude);
                      num distance =
                          geodesy.distanceBetweenTwoGeoPoints(p1, p2);

                      if (distance >= 10) {
                        StreamLogData.currentlocation = _templocation;
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .set({
                          'longitude': StreamLogData.currentlocation.longitude,
                          'latitude': StreamLogData.currentlocation.latitude,
                          'isactive': true,
                        }, SetOptions(merge: true));
                      }
                    }
                    if (snap.hasError) {
                      Location.instance.requestPermission();
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Center(
                      child: Text(
                        "SOS ACTIVE",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }),
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.37),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            shape: CircleBorder(),
          )
        : RawMaterialButton(
            fillColor: Colors.green,
            onPressed: () {
              setState(() {
                StreamLogData.isactive = true;
              });
            },
            elevation: 5,
            child: Center(
              child: Text(
                StreamLogData.isactive ? "SOS ACTIVE" : "SOS",
                style: TextStyle(fontSize: StreamLogData.isactive ? 20 : 45),
              ),
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.37),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            shape: CircleBorder(),
          );
  }
}
