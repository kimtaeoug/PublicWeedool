import 'package:package_info_plus/package_info_plus.dart';

class PackageUtil {
  static final PackageUtil _instance = PackageUtil._();

  PackageUtil._();

  factory PackageUtil() => _instance;

  PackageInfo? _packageInfo = null;

  void init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get appName => _packageInfo?.appName ?? '';

  String get packageName => _packageInfo?.packageName ?? '';

  String get version => _packageInfo?.version ?? '';

  String get buildNumber => _packageInfo?.buildNumber ?? '';
}
