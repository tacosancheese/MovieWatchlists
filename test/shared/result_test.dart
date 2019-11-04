import 'package:movie_watchlists/shared/result.dart';
import 'package:test/test.dart';

main() {

  test('should create a successful data type', () {
    final result = Result.success(true);
    expect(result.exception, isNull);
    expect(result.result, isNotNull);

    expect(result.hasResult, isTrue);
    expect(result.hasError, isFalse);
  });

  test('should create a failed data type', () {
    final result = Result.failure(Exception());
    expect(result.exception, isNotNull);
    expect(result.result, isNull);

    expect(result.hasResult, isFalse);
    expect(result.hasError, isTrue);
  });
}