import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Cast extends Equatable {

  final int castId;
  final String character;
  final String creditId;
  final int gender;
  final int id;
  final String name;
  final int order;
  final String profilePath;

  Cast._({
    @required this.castId,
    @required this.character,
    @required this.creditId,
    @required this.gender,
    @required this.id,
    @required this.name,
    @required this.order,
    @required this.profilePath
  });

  Cast._fromJson(final Map<String, dynamic> json) :
    castId = json["cast_id"],
    character = json["character"],
    creditId = json["credit_id"],
    gender = json["gender"],
    id = json["id"],
    name = json["name"],
    order = json["order"],
    profilePath = json["profile_path"];

  static List<Cast> fromJsonResponse(dynamic json) {
    return (json["cast"] as List)
      .map((item) => Cast._fromJson(item))
      .toList();
  }

  bool get hasProfilePath => profilePath != null;
  String get smallProfilePath => "https://image.tmdb.org/t/p/w300/" + profilePath;
}