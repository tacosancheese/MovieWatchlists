class Genre {

  final int id;
  final String name;

  Genre(this.id, this.name);

  Genre.fromJson(final Map<String, dynamic> json) :
      id = json["id"],
      name = json["name"];

  static List<Genre> fromJsonResponse(dynamic json) {
    return (json["genres"] as List)
      .map((item) => Genre.fromJson(item))
      .toList();
  }
}