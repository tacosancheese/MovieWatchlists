import 'package:flutter_test/flutter_test.dart';
import 'package:movie_watchlists/shared/language_util.dart';

main() {

  test('should retrieve language for lang code', () {
    expect(LanguageUtil.getLanguage("en"), "English");
  });
}