import 'package:movie_watchlists/shared/language_util.dart';

import 'genre.dart';
import 'language.dart';

class MovieDetails {
  final bool adult;
  final String backdropPath;
  // belongsToCollection
  final int budget;
  final List<Genre> genres;
  final String homepage;
  final int id;
  final String imdbId;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  // final int popularity;
  final String posterPath;
  // productionCompanies
  // productionCountries;
  final String releaseDate;
  final int revenue;
  final int runTime;
  final List<Language> spokenLanguages;
  final String status;
  final String tagline;
  final String title;
  final bool video;
  //final double voteAverage;
  //final int voteCount;

  MovieDetails.fromJson(final Map<String, dynamic> json):
    adult = json["adult"],
    backdropPath = json["backdrop_path"],
    budget = json["budget"],
    homepage = json["homepage"],
    genres = Genre.fromJsonResponse(json),
    id = json["id"],
    imdbId = json["imdb_id"],
    originalLanguage = json["original_language"],
    originalTitle = json["original_title"],
    overview = json["overview"],
    posterPath = json["poster_path"],
    releaseDate = json["release_date"],
    revenue = json["revenue"],
    runTime = json["runtime"],
    spokenLanguages = Language.fromJsonResponse(json),
    status = json["status"],
    tagline = json["tagline"],
    title = json["title"],
    video = json["video"];

  static List<MovieDetails> fromJsonResponse(dynamic json) {
    return (json["results"] as List)
      .map((item) => MovieDetails.fromJson(item))
      .toList();
  }

  String get _baseImageUrl => "https://image.tmdb.org/t/p/";

  String get originalPosterPathUrl => posterPath != null
    ?_baseImageUrl + "original" + posterPath : null;

  String get smallPosterPathUrl => posterPath != null
    ?_baseImageUrl + "w300" + posterPath : null;

  String get originalBackdropPathUrl => backdropPath != null
    ?_baseImageUrl + "original" + backdropPath : null;

  String get smallBackdropPathUrl => backdropPath != null
    ? _baseImageUrl + "w300" + backdropPath : null;

  // TODO: localization
  String get runTimeInHoursAndMinutes => runTime == null ? "0 min" :
    (runTime ~/ 60).toString() + "h " + (runTime % 60).toString() + "min";

  // TODO: localization
  String get fullOriginalLanguage => LanguageUtil.getLanguage(originalLanguage);
}