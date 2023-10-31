import 'package:firedart/firedart.dart';

const collectionUsers = "users_test";

class UserDao {
  UserDao(this._firestore);

  final Firestore _firestore;

  CollectionReference get collection => _firestore.collection(collectionUsers);

  Future<String> getLocaleById(int userId) async {
    final doc = await collection.document(userId.toString()).get();
    return doc['user_locale'];
  }

  Future<void> storeUserLocale(int userId, locale) async {
    await collection.document(userId.toString()).update({
      'user_locale' : locale
    });
  }

  Future<bool> isOnboarded(int userId) async {
    return false;
  }
}
