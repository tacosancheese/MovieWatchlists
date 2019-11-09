import 'package:equatable/equatable.dart';
import 'package:movie_watchlists/models/tmdb_image.dart';

class Movie extends Equatable {

  //final int voteCount;
  final int id;
  final bool video;
  //final voteAverage
  final String title;
  //final popularity
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final bool adult;
  final String overview;
  final String releaseDate;
  final TmdbImage tmdbImage;

  Movie.fromJson(final Map<String, dynamic> json):
      id = json["id"],
      video = json["video"],
      tmdbImage = TmdbImage.fromSnapshot(json),
      originalLanguage = json["original_language"],
      originalTitle = json["original_title"],
      genreIds = (json["genre_ids"] as List).cast<int>(),
      adult = json["adult"],
      title = json["title"],
      overview = json["overview"],
      releaseDate = json["release_date"];

  static List<Movie> fromJsonResponse(dynamic json) {
    return (json["results"] as List)
      .map((item) => Movie.fromJson(item))
      .toList();
  }
}