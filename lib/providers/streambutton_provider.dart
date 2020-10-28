import 'package:flutter/widgets.dart';
import 'package:location/location.dart';

class StreamLogData with ChangeNotifier {
  static bool isactive = false;
  static LocationData currentlocation;
  static LocationData startlocation;
  static LocationData endlocation;
  static DateTime starttime;
  static DateTime endtime;
}
