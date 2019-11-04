class LanguageUtil {

  // TODO: load these from somewhere + localization
  static Map<String, String> _languages = {
    "en" : "English",
    "ja" : "Japanese"
  };

  static String getLanguage(final String langCode) {
    if (_languages.containsKey(langCode)) {
      return _languages[langCode];
    }

    return langCode;
  }
}