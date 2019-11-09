import 'package:flutter/foundation.dart';

class Genre {

  final int id;
  final String name;

  Genre({
    @required this.id,
    @required this.name
  });

  Genre.fromJson(final Map<String, dynamic> json) :
      id = json["id"],
      name = json["name"];

  static List<Genre> fromJsonResponse(dynamic json) {
    return (json["genres"] as List)
      .map((item) => Genre.fromJson(item))
      .toList();
  }
}