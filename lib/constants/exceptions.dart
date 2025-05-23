class ImageNotFoundException implements Exception {
  final String message;

  ImageNotFoundException(this.message);

  @override
  String toString() => 'ImageNotFoundException: $message';
}

class ConnectivityException implements Exception {
  final String message;

  ConnectivityException(this.message);

  @override
  String toString() => 'ConnectivityException: $message';
}
