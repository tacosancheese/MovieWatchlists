import 'package:flutter_test/flutter_test.dart';
import 'package:movie_watchlists/models/cast.dart';

import '../test_utils.dart';

main() async {
  
  final json = await readJsonStringFromFile(CAST_JSON_PATH);
  final items = Cast.fromJsonResponse(json);

  test('should deserialize into model', () {
    expect(items, isNotEmpty);
    
    final item = items.first;
    expect(item.castId, equals(1));
    expect(item.character, equals("Simba (voice)"));
    expect(item.creditId, equals("58a79add9251417ee8000f5d"));
    expect(item.gender, equals(2));
    expect(item.id, greaterThan(0));
    expect(item.name, equals("Donald Glover"));
    expect(item.order, equals(0));
    expect(item.profilePath, contains(".jpg"));
  });

  test('should return true if path url exists', () {
    final item = items.first;

    expect((item.hasProfilePath), isTrue);
  });

  test('should form small path url', () {
    final item = items.first;

    expect(item.smallProfilePath, startsWith("https"));
    expect(item.smallProfilePath, contains(item.profilePath));
  });
}