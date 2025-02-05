import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:weedool/models/reserve/lat_long_model.dart';
import 'package:weedool/utils/logger.dart';
import 'package:weedool/utils/preference_util.dart';
// import 'package:location/location.dart';

class LocationUtil{
  static final LocationUtil _insctance = LocationUtil._();
  LocationUtil._();
  factory LocationUtil() => _insctance;
  // final Location location = Location();
  //
  // Future<LocationData> getLocation()async{
  //   return await location.getLocation();
  // }
  // StreamSubscription<LocationData>? stream = null;
  //
  // void startListeningLocation(Function(LocationData) listener){
  //   stream = location.onLocationChanged.listen(listener);
  // }
  // void cancel(){
  //   if(stream != null){
  //     stream?.cancel();
  //   }
  // }

  final PreferenceUtil _pref = PreferenceUtil();

  Future<LatLongModel> getCurrentLocation()async{
    try{
      Position? position = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);
      if(position != null){
        _pref.setLatLong(position.latitude, position.longitude);
      }
      return LatLongModel(position?.latitude ?? _pref.lat, position?.longitude ?? _pref.long);
    }catch(e){
      return LatLongModel(_pref.lat, _pref.long);
    }
  }
  StreamSubscription<Position>? stream = null;
  void startListeningLocation(Function(Position) listener){
    stream = Geolocator.getPositionStream().listen(listener);
  }
  void cancel(){
    if(stream != null){
      stream?.cancel();
    }
  }
}