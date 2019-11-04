class Result<R, E extends Exception> {

  final R result;
  final E exception;

  Result._() : result = null, exception = null {
    throw Exception("Use a named constructor");
  }

  Result.failure(final E exception) : result = null, exception = exception;
  Result.success(final R result) : result = result, exception = null;

  bool get hasResult => result != null && exception == null;
  bool get hasError => result == null && exception != null;
}