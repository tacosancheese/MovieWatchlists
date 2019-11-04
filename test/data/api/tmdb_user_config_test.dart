import 'package:movie_watchlists/data/api/tmdb_user_config.dart';
import 'package:movie_watchlists/data/preferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

main() {

  tearDownAll(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  test('should get config value', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final userPrefs = UserPreferences(sharedPrefs: prefs);
    userPrefs.setAdult(true);

    final userConfig1 = TmdbUserConfig(userPrefs: userPrefs);
    expect(userConfig1.adult, isTrue);

    userPrefs.setAdult(false);
    final userConfig2 = TmdbUserConfig(userPrefs: userPrefs);
    expect(userConfig2.adult, isFalse);
  });
}