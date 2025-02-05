import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weedool/utils/logger.dart';

class PreferenceUtil {
  static final PreferenceUtil _instance = PreferenceUtil._();

  PreferenceUtil._();

  factory PreferenceUtil() => _instance;

  final String SLEEP_KEY = 'SLEEP_KEY';
  final String MOOD_KEY = 'MOOD_KEY';

  final String LATITUDE_KEY = 'LATITUDE_KEY';
  final String LONGITUDE_KEY = 'LONGITUDE_KEY';

  final String BEFORE_LOGIN_KEY = 'BEFORE_LOGIN_KEY';

  SharedPreferences? _pref = null;

  void init() async {
    _pref = await SharedPreferences.getInstance();
    checkSleep.value = _pref?.getBool(SLEEP_KEY) ?? false;
    checkMood.value = _pref?.getBool(MOOD_KEY) ?? false;
    latitude.value = _pref?.getDouble(LATITUDE_KEY) ?? 37.5665851;
    longitude.value = _pref?.getDouble(LONGITUDE_KEY) ?? 126.9782038;
    beforeUUID.value = _pref?.getString(BEFORE_LOGIN_KEY) ?? '';
  }

  final ValueNotifier<bool> checkSleep = ValueNotifier(false);

  bool get sleep => checkSleep.value;

  ///
  /// false -> 안봄, true -> 봄
  ///
  void setCheckSleep(bool input) {
    if (_pref != null) {
      checkSleep.value = input;
      _pref?.setBool(SLEEP_KEY, input);
    }
  }

  final ValueNotifier<bool> checkMood = ValueNotifier(false);

  bool get mood => checkMood.value;

  ///
  /// 0->none, 1-> haveToShow, 2 -> showed
  ///
  void setCheckMood(bool input) {
    if (_pref != null) {
      checkMood.value = input;
      _pref?.setBool(MOOD_KEY, input);
    }
  }

  ///
  /// latitude, longitude
  ///
  final ValueNotifier<double> latitude = ValueNotifier(37.5665851);
  final ValueNotifier<double> longitude = ValueNotifier(126.9782038);

  double get lat => latitude.value;

  double get long => longitude.value;

  void setLatLong(double lat, double long) {
    if (_pref != null) {
      _pref?.setDouble(LATITUDE_KEY, lat);
      _pref?.setDouble(LONGITUDE_KEY, long);
      latitude.value = lat;
      longitude.value = long;
    }
  }

  ///
  /// Before uuid
  ///
  final ValueNotifier<String> beforeUUID = ValueNotifier('');

  String get beforeUuid => beforeUUID.value;

  void setBeforeUUID(String input) {
    if (_pref != null) {
      _pref?.setString(BEFORE_LOGIN_KEY, input);
      beforeUUID.value = input;
    }
  }
}
