import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../providers/logs_provider.dart';
import '../providers/logs_provider.dart';

class StreamButton extends StatefulWidget {
  bool isactive = false;
  LocationData currentlocation;
  LocationData startlocation;
  LocationData endlocation;
  DateTime starttime;
  DateTime endtime;
  @override
  _StreamButtonState createState() => _StreamButtonState();
}

class _StreamButtonState extends State<StreamButton> {
  Geodesy geodesy = Geodesy();

  @override
  Widget build(BuildContext context) {
    return widget.isactive
        ? RawMaterialButton(
            fillColor: Colors.red,
            onPressed: () {
              widget.endlocation = widget.currentlocation;
              widget.endtime = DateTime.now();
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .set({
                    'isactive': false,
                    'longitude': widget.currentlocation.longitude,
                    'latitude': widget.currentlocation.latitude
                  }, SetOptions(merge: true))
                  .then((value) => widget.isactive = false)
                  .then((value) =>
                      Provider.of<LogsProvider>(context, listen: false)
                          .insertlog(widget.starttime, widget.endtime,
                              widget.startlocation, widget.endlocation))
                  .then((value) => setState(() {
                        widget.isactive = false;
                      }));
            },
            elevation: 5,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: StreamBuilder(
                  stream: Location.instance.onLocationChanged,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      if (widget.currentlocation == null) {
                        widget.currentlocation = snap.data;
                        widget.startlocation = snap.data;
                        widget.starttime = DateTime.now();

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .set({
                          'isactive': true,
                          'longitude': widget.currentlocation.longitude,
                          'latitude': widget.currentlocation.latitude
                        }, SetOptions(merge: true));
                      }
                      final LocationData _templocation = snap.data;
                      LatLng p1 = LatLng(
                          _templocation.latitude, _templocation.longitude);
                      LatLng p2 = LatLng(widget.currentlocation.latitude,
                          widget.currentlocation.longitude);
                      num distance =
                          geodesy.distanceBetweenTwoGeoPoints(p1, p2);

                      if (distance >= 20) {
                        widget.currentlocation = _templocation;
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .set({
                          'isactive': true,
                          'longitude': widget.currentlocation.longitude,
                          'latitude': widget.currentlocation.latitude
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
                widget.isactive = true;
              });
            },
            elevation: 5,
            child: Center(
              child: Text(
                widget.isactive ? "SOS ACTIVE" : "SOS",
                style: TextStyle(fontSize: widget.isactive ? 20 : 45),
              ),
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.37),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            shape: CircleBorder(),
          );
  }
}
