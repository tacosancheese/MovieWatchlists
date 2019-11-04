class Language {

  final String isoCode;
  final String name;

  Language._fromJson(final Map<String, dynamic> json):
      isoCode = json["iso_639_1"],
      name = json["name"];

  static List<Language> fromJsonResponse(dynamic json) {
    return (json["spoken_languages"] as List)
      .map((item) => Language._fromJson(item))
      .toList();
  }
}