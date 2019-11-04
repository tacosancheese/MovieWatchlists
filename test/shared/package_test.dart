import 'package:flutter/services.dart';
import 'package:movie_watchlists/shared/package.dart';
import 'package:test/test.dart';

main() {

  void mockMethodChannel(final String versionNumber, final String buildNumber) {
    const MethodChannel('plugins.flutter.io/package_info')
      .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{
          'appName': '',
          'packageName': 'A.B.C',
          'version': versionNumber,
          'buildNumber': buildNumber
        };
      }
      return null;
    });
  }

  test('should retrieve app version', () async {
    mockMethodChannel("1.0.0", "1");
    final pkg = Package();
    expect(await pkg.appVersion(), equals("1.0.0 + 1"));
  });
}