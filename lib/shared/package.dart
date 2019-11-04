import 'package:package_info/package_info.dart';

class Package {

  Future<String> appVersion() async {
    final info = await PackageInfo.fromPlatform();
    return "${info.version} + ${info.buildNumber}";
  }
}