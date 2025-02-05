import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weedool/components/wd_common.dart';
import 'package:weedool/utils/logger.dart';

class PermissionUtil {
  static final PermissionUtil _instance = PermissionUtil._();

  PermissionUtil._();

  factory PermissionUtil() => _instance;

  final ValueNotifier<bool> notiPermission = ValueNotifier(false);
  final ValueNotifier<bool> locationPermission = ValueNotifier(false);

  bool get noti => notiPermission.value;

  bool get location => locationPermission.value;

  //Noti
  Future<bool> checkNotiPermission() async {
    WDLog.e('11');
    Permission.notification.request().then((value){
      WDLog.e('value : $value');
    });
    WDLog.e('12');
    // WDLog.e('11');
    // WDLog.e('11');
    // PermissionStatus status = await Permission.notification.request();
    // //todo
    // WDLog.e('12');
    // if (status == PermissionStatus.granted) {
    //   notiPermission.value = true;
    // } else {
    //   notiPermission.value = false;
    // }
    return true;
  }

  //android -> denied도 요청안함.
  void requestNotiPermission(Function() pdFunction) async {
    await Permission.notification.request().then((value) {
      if (value == PermissionStatus.granted) {
        notiPermission.value = true;
      } else {
        notiPermission.value = false;
        if (value == PermissionStatus.permanentlyDenied) {
          pdFunction.call();
        }
      }
    });
  }

  //위치
  void checkLocationPermission() async {
    await Permission.location.status.then((value) {
      if (value == PermissionStatus.granted) {
        locationPermission.value = true;
      } else {}
    });
  }

  void requestLocationPermission(
      {bool isInit = true,
      Function()? function,
      Function()? successFunction}) async {
    await Geolocator.checkPermission().then((value) async {
      if (value == LocationPermission.whileInUse ||
          value == LocationPermission.always) {
        locationPermission.value = true;
        if (successFunction != null) {
          successFunction.call();
        } else {
          WDCommon().initLocation();
        }
      } else {
        await Geolocator.requestPermission().then((value) {
          if (value == LocationPermission.deniedForever ||
              value == LocationPermission.unableToDetermine) {
            locationPermission.value = false;
            if (function != null) {
              function.call();
            }
          } else if (value == LocationPermission.always ||
              value == LocationPermission.whileInUse) {
            locationPermission.value = true;
            if (successFunction != null) {
              successFunction.call();
            } else {
              WDCommon().initLocation();
            }
          }
        });
      }
    });
  }

  Future<bool> checkLocation() async {
    WDLog.e('1');
    PermissionStatus status = await Permission.location.request();
    WDLog.e('2');
    if (status == PermissionStatus.granted) {
          locationPermission.value = true;
        } else {
          locationPermission.value = false;
        }
    WDLog.e('3');
    return true;

    //    PermissionStatus status = await Permission.notification.request();
    //     if (status == PermissionStatus.granted) {
    //       notiPermission.value = true;
    //     } else {
    //       notiPermission.value = false;
    //     }
    //     return true;
    LocationPermission permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.whileInUse ||
    //     permission == LocationPermission.always) {
    //   locationPermission.value = true;
    // } else {
    //   locationPermission.value = false;
    // }
    // return true;
  }
  final permissionList = [Permission.location, Permission.notification];
  void checkPermission() async{
    for (Permission e in permissionList) {
      WDLog.e('heeey! : $e');
      e.request();
    }
  }
}
