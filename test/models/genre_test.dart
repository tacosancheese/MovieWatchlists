import 'package:movie_watchlists/models/genre.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

main() async {

  final json = await readJsonStringFromFile(GENRE_JSON_PATH);
  final items = Genre.fromJsonResponse(json);

  test('should deserialize json', () async {
    expect(items, isNotEmpty);
    expect(items.length, greaterThan(10));

    final item = items.first;
    expect(item.id, equals(28));
    expect(item.name, equals("Action"));
  });
}