import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapStream extends StatefulWidget {
  final String uid;
  MapStream(this.uid);
  //String c = FirebaseAuth.instance.currentUser.uid;
  // MapStream({this.uid = "t9xy2KueuBbiN1b5U5UOdDnbUu32"});
  static const routename = '/mapstream';
  @override
  _MapStreamState createState() => _MapStreamState();
}

class _MapStreamState extends State<MapStream> {
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  LatLng _center = const LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _c;

  @override
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
      _c = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
        builder: (ctx, snap) {
          if (snap.hasError)
            return Scaffold(
              appBar: AppBar(
                title: Text('An Error Occoured'),
                backgroundColor: Colors.green[700],
              ),
              body: Center(
                child: Text("An Error Occoured"),
              ),
            );

          if (snap.hasData) {
            final DocumentSnapshot _snap = snap.data;

            final _data = _snap.data();

            if (_data['isactive']) {
              _center = LatLng(_data['latitude'], _data['longitude']);

              if (_c != null) _c.animateCamera(CameraUpdate.newLatLng(_center));

              return Scaffold(
                appBar: AppBar(
                  title: Text('Stream User Location'),
                  backgroundColor: Colors.green[700],
                ),
                body: GoogleMap(
                  markers: Set.from([
                    Marker(
                        infoWindow: InfoWindow(
                            title: _data['name'] != null
                                ? _data['name']
                                : "Loading"),
                        markerId: MarkerId('1'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(15),
                        position: _center)
                  ]),
                  myLocationButtonEnabled: true,
                  mapToolbarEnabled: true,
                  buildingsEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: (controller) => _onMapCreated(controller),
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 100,
                  ),
                ),
              );
            } else if (!_data['isactive']) {
              return Scaffold(
                appBar: AppBar(
                  title: Text("NO STREAM"),
                ),
                body: Center(
                  child: Text("The Stream has ended"),
                ),
              );
            }
          }

          return Scaffold(
              body: Center(
            child: Text(widget.uid),
          ));
        });
  }
}
