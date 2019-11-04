import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/preferences/user_preferences.dart';

class TmdbUserConfig {

  final UserPreferences _preferences;

  TmdbUserConfig({
    @required final UserPreferences userPrefs
  }): this._preferences = userPrefs;

  bool get adult => _preferences.adult;
}