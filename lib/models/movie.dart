import 'package:equatable/equatable.dart';

import 'genre.dart';
import 'movie_.dart';

class Movie extends Equatable {

  final Movie_ _item;
  final List<Genre> _genres;

  Movie(this._item, this._genres);

  int get id => _item.id;

  String get originalTitle => _item.originalTitle;
  List<Genre> get genres => _genres;

  String get overview => _item.overview;

  bool get hasPosterUrl => originalPosterPathUrl != null;

  String get originalPosterPathUrl => _item.originalPosterPathUrl;
  String get smallPosterPathUrl => _item.smallPosterPathUrl;

  bool get hasBackdropUrl => originalBackdropPathUrl != null;

  String get originalBackdropPathUrl => _item.originalBackdropPathUrl;
  String get smallBackdropPathUrl => _item.smallBackdropPathUrl;

  Movie._toMovieItem(final Movie_ movie, final List<Genre> genres) :
    _item = movie,
    _genres = genres
      .where((item) => movie.genreIds.contains(item.id))
      .toList();

  static List<Movie> toMovies(
    final List<Movie_> movies,
    final List<Genre> genres) {
    return movies
      .map((Movie_ item) => Movie._toMovieItem(item, genres))
      .toList();
  }
}