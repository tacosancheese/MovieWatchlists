import 'package:flutter_test/flutter_test.dart';
import 'package:movie_watchlists/models/movie_details.dart';

import '../test_utils.dart';

void main() async {

  final json = await readJsonStringFromFile(MOVIE_DETAILS_JSON_PATH);
  final MovieDetails details = MovieDetails.fromJson(json);

  test('should deserialize fields correctly', () {
    expect(details.adult, isFalse);
    expect(details.backdropPath, endsWith(".jpg"));
    expect(details.budget, greaterThan(0));
    expect(details.homepage, startsWith("https"));
    expect(details.id, isNot((0)));
    expect(details.imdbId, startsWith("tt"));
    expect(details.originalLanguage, equals("en"));
    expect(details.originalTitle, equals("Avengers: Endgame"));
    expect(details.overview, startsWith("After the devastating"));
    expect(details.posterPath, endsWith(".jpg"));
    expect(details.releaseDate, equals("2019-04-24"));
    expect(details.revenue, greaterThan(0));
    expect(details.runTime, greaterThan(0));
    expect(details.status, equals("Released"));
    expect(details.tagline, equals("Part of the journey is the end."));
    expect(details.title, equals("Avengers: Endgame"));
    expect(details.video, isFalse);
    expect(details.spokenLanguages, isNotEmpty);
  });

  test('should return runtimeInHoursAndMinutes', () {
    expect(details.runTimeInHoursAndMinutes, "3h 1min");
  });
}