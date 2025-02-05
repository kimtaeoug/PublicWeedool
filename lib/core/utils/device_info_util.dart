import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';

class DeviceInfoUtil {
  static final DeviceInfoUtil _instance = DeviceInfoUtil._();
  DeviceInfoUtil._();
  factory DeviceInfoUtil() => _instance;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  final ValueNotifier<AndroidDeviceInfo?> _androidDeviceInfo = ValueNotifier(null);
  final ValueNotifier<IosDeviceInfo?> _iosDeviceInfo = ValueNotifier(null);

  AndroidDeviceInfo? get android => _androidDeviceInfo.value;
  IosDeviceInfo? get ios => _iosDeviceInfo.value;

  void init()async{
    _androidDeviceInfo.value = await _deviceInfoPlugin.androidInfo;
    _iosDeviceInfo.value = await _deviceInfoPlugin.iosInfo;
  }
}