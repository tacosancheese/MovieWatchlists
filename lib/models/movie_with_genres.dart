import 'package:equatable/equatable.dart';

import 'genre.dart';
import 'movie.dart';

class MovieWithGenres extends Equatable {

  final Movie _item;
  final List<Genre> _genres;

  MovieWithGenres(this._item, this._genres);

  int get id => _item.id;

  String get originalTitle => _item.originalTitle;
  List<Genre> get genres => _genres;

  String get overview => _item.overview;

  bool get hasPosterUrl => originalPosterPathUrl != null;

  String get originalPosterPathUrl => _item.tmdbImage.originalPosterPathUrl;
  String get smallPosterPathUrl => _item.tmdbImage.smallPosterPathUrl;

  bool get hasBackdropUrl => originalBackdropPathUrl != null;

  String get originalBackdropPathUrl => _item.tmdbImage.originalBackdropPathUrl;
  String get smallBackdropPathUrl => _item.tmdbImage.smallBackdropPathUrl;

  MovieWithGenres._toMovieItem(final Movie movie, final List<Genre> genres) :
    _item = movie,
    _genres = genres
      .where((item) => movie.genreIds.contains(item.id))
      .toList();

  static List<MovieWithGenres> toMovies(
    final List<Movie> movies,
    final List<Genre> genres) {
    return movies
      .map((Movie item) => MovieWithGenres._toMovieItem(item, genres))
      .toList();
  }
}