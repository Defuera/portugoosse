import 'package:database/database.dart';
import 'package:firedart/firedart.dart';

class Database {
  const Database._();

  static Future<void> initialize() async {
    if (!Firestore.initialized) {
      Firestore.initialize('portugoose', useApplicationDefaultAuth: true);
    }
  }

  static UserDao createUserDao() => UserDao(Firestore.instance);

  static DialogDao createDialogDao() => DialogDao(Firestore.instance);

  static UserProgressDao createUserProgressDao() => UserProgressDao(Firestore.instance);

}
