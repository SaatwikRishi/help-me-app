import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helpmeapp/screens/mapstream.dart';

final Map<String, MessageBean> _items = <String, MessageBean>{};

//Model class to represent the message return by FCM
class MessageBean {
  MessageBean({this.itemId});
  final String itemId;

  StreamController<MessageBean> _controller =
      StreamController<MessageBean>.broadcast();
  Stream<MessageBean> get onChanged => _controller.stream;

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = MapStream.routename;
    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => MapStream(itemId),
      ),
    );
  }
}
