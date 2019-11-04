import 'package:equatable/equatable.dart';

class Movie_ extends Equatable {

  //final int voteCount;
  final int id;
  final bool video;
  //final voteAverage
  final String title;
  //final popularity
  final String posterPath;
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final String backdropPath;
  final bool adult;
  final String overview;
  final String releaseDate;

  String get _baseImageUrl => "https://image.tmdb.org/t/p/";

  Movie_.fromJson(final Map<String, dynamic> json):
      id = json["id"],
      video = json["video"],
      posterPath = json["poster_path"],
      originalLanguage = json["original_language"],
      originalTitle = json["original_title"],
      genreIds = (json["genre_ids"] as List).cast<int>(),
      backdropPath = json["backdrop_path"],
      adult = json["adult"],
      title = json["title"],
      overview = json["overview"],
      releaseDate = json["release_date"];

  static List<Movie_> fromJsonResponse(dynamic json) {
    return (json["results"] as List)
      .map((item) => Movie_.fromJson(item))
      .toList();
  }

  String get originalPosterPathUrl => posterPath != null
    ?_baseImageUrl + "original" + posterPath : null;

  String get smallPosterPathUrl => posterPath != null
    ?_baseImageUrl + "w300" + posterPath : null;

  String get originalBackdropPathUrl => backdropPath != null
    ?_baseImageUrl + "original" + backdropPath : null;

  String get smallBackdropPathUrl => backdropPath != null
    ? _baseImageUrl + "w300" + backdropPath : null;

}