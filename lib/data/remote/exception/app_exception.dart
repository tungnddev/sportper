class AppException implements Exception {
  AppException([this._message = ""]);
  final dynamic _message;

  String toString() {
    return "$_message";
  }
}

class UnknownException extends AppException {
  UnknownException() : super('#Something went wrong');
}

enum NetworkExceptionType {
  ApiError,
  ExpiredToken,
  LostConnection,
  Unknown
}

class NetException extends AppException {
  NetworkExceptionType type;
  String message;

  NetException(this.type, this.message);

  @override
  String toString() {
    return message;
  }
}
