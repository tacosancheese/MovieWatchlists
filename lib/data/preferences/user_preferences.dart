import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// NOTE: Shared preferences keys need to have "flutter." prefix to be testable :/
const String _PREFIX = "flutter.";

const String PREF_KEY_ANALYTICS = _PREFIX + "analytics";
const String PREF_KEY_NOTIFICATIONS = _PREFIX + "notifications";
const String PREF_KEY_ADULT = _PREFIX + "adult";
const String PREF_KEY_HIGH_QUALITY_IMAGE = _PREFIX + "hq_images";

class UserPreferences {
  final SharedPreferences _preferences;

  UserPreferences({
    @required final SharedPreferences sharedPrefs
    }) : this._preferences = sharedPrefs;

  bool _getBool(final String key) =>
      _preferences.containsKey(key) ? _preferences.getBool(key) : false;

  Future<bool> _setBool(final String key, bool value) async =>
      await _preferences.setBool(key, value);

  // read values
  bool get analytics => _getBool(PREF_KEY_ANALYTICS);

  bool get notifications => _getBool(PREF_KEY_NOTIFICATIONS);

  bool get adult => _getBool(PREF_KEY_ADULT);

  bool get highQualityImages => _getBool(PREF_KEY_HIGH_QUALITY_IMAGE);

  // update values
  Future<bool> setAnalytics(final bool analytics) async =>
      _setBool(PREF_KEY_ANALYTICS, analytics);

  Future<bool> setNotifications(final bool notifications) async =>
      _setBool(PREF_KEY_NOTIFICATIONS, notifications);

  Future<bool> setAdult(final bool adult) async =>
      _setBool(PREF_KEY_ADULT, adult);

  Future<bool> setHighQualityImages(final bool highQuality) async =>
      _setBool(PREF_KEY_HIGH_QUALITY_IMAGE, highQuality);
}
