import 'package:database/src/user_dao.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firedart/firedart.dart';

class Database {
  const Database._();

  static void initialize() async {
    if (!Firestore.initialized) {
      authenticate();
      Firestore.initialize('portugoose', useApplicationDefaultAuth: true);
    }
  }

  // static TokenDao createTokenDao() => TokenDao(Firestore.instance);

  static UserDao createUserDao() => UserDao(Firestore.instance);

  // static DialogDao createDialogDao() => DialogDao(Firestore.instance);
}

void authenticate() async {
  FirebaseAdmin.instance.initializeApp(AppOptions(
    credential: FirebaseAdmin.instance.certFromPath('../.keys/scf-service-account-key.json'),
    databaseUrl: "https://nakleika.firebaseio.com",
  ));
}
