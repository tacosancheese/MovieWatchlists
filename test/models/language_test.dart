import 'package:movie_watchlists/models/language.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

main() async {

  final json = await readJsonStringFromFile(MOVIE_DETAILS_JSON_PATH);
  final items = Language.fromJsonResponse(json);

  test('should deserialize into model', () {
    expect(items, isNotEmpty);

    final item = items.first;
    expect(item.isoCode, equals("en"));
    expect(item.name, equals("English"));
  });
}