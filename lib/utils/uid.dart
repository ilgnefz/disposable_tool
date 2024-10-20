import 'package:uuid/uuid.dart';

class AppUid {
  static String get uid {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
