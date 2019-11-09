import 'package:movie_watchlists/models/genre.dart';
import 'package:movie_watchlists/models/movie_with_genres.dart';
import 'package:movie_watchlists/models/movie.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

main() async {

  final List<Movie> movies = Movie
    .fromJsonResponse(await readJsonStringFromFile(MOVIES_JSON_PATH));

  final List<Genre> genres = Genre
    .fromJsonResponse(await readJsonStringFromFile(GENRE_JSON_PATH));

  test('should convert discovery item and genre to movie', () async {
    final List<MovieWithGenres> result = MovieWithGenres.toMovies(movies, genres);
    expect(result, isNotEmpty);
  });

  test('movie should contain genres based on genreIds', () async {
    final List<MovieWithGenres> result = MovieWithGenres.toMovies(movies, genres);
    expect(result, isNotEmpty);

    final movie = result.first;
    expect(movie.genres, isNotEmpty);
    expect(movie.genres.map((genre) => genre.id).toList(),
      containsAll(movies.first.genreIds));
  });
}