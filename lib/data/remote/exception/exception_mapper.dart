
import 'app_exception.dart';

class ExceptionMapper {
  static AppException map(Object err) {
    if (err is AppException) {
      print(err.toString());
      return err;
    } else {
      return UnknownException();
    }
  }
}
