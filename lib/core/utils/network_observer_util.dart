import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:weedool/utils/logger.dart';

class NetworkObserverUtil {
  static final NetworkObserverUtil _instance = NetworkObserverUtil._();

  NetworkObserverUtil._();

  factory NetworkObserverUtil() => _instance;

  final ValueNotifier<bool> network = ValueNotifier(true);

  bool get checkNetwork => network.value;

  late StreamSubscription<List<ConnectivityResult>> subscription;

  final Connectivity _connectivity = Connectivity();

  void init() {
    subscription = _connectivity.onConnectivityChanged.listen(_listener);
  }

  void dispose() {
    subscription.cancel();
  }

  void _listener(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      network.value = false;
      WDLog.e('network none value : ${network.value}');
    } else {
      network.value = true;
      WDLog.e('network value : ${network.value}');
    }
  }
}
