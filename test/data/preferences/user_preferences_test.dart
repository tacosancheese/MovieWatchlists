import 'package:movie_watchlists/data/preferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

main() async {

  tearDownAll(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  test('should be false by default', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final userPrefs = UserPreferences(sharedPrefs: prefs);
    expect(userPrefs.adult, isFalse);
  });

  test('should update analytics values', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final userPrefs = UserPreferences(sharedPrefs: prefs);
    expect(userPrefs.analytics, isFalse);

    await userPrefs.setAnalytics(true);
    expect(userPrefs.analytics, isTrue);

    await userPrefs.setAnalytics(false);
    expect(userPrefs.analytics, isFalse);
  });

  test('should update notifications values', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final userPrefs = UserPreferences(sharedPrefs: prefs);
    expect(userPrefs.notifications, isFalse);

    await userPrefs.setNotifications(true);
    expect(userPrefs.notifications, isTrue);

    await userPrefs.setNotifications(false);
    expect(userPrefs.notifications, isFalse);
  });

  test('should update adult values', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final userPrefs = UserPreferences(sharedPrefs: prefs);
    expect(userPrefs.adult, isFalse);

    await userPrefs.setAdult(true);
    expect(userPrefs.adult, isTrue);

    await userPrefs.setAdult(false);
    expect(userPrefs.adult, isFalse);
  });

  test('should update high quality values', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final userPrefs = UserPreferences(sharedPrefs: prefs);
    expect(userPrefs.highQualityImages, isFalse);

    await userPrefs.setHighQualityImages(true);
    expect(userPrefs.highQualityImages, isTrue);

    await userPrefs.setHighQualityImages(false);
    expect(userPrefs.highQualityImages, isFalse);
  });

}