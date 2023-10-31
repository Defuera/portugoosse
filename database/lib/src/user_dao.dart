import 'package:firedart/firedart.dart';

const collectionUsers = "users_test";

class UserDao {
  UserDao(this._firestore);

  final Firestore _firestore;

  CollectionReference get collection => _firestore.collection(collectionUsers);

  Future<String> getLocaleById(int userId) async {
    final doc = await _userDoc(userId).get();
    return doc['user_locale'];
  }

  Future<void> storeUserLocale(int userId, locale) => _userDoc(userId).update({
        'user_locale': locale,
      });

  Future<bool> isOnboarded(int userId) async {
    final value = await _userDoc(userId).get();
    return value.map['is_onboarded'] ?? false;
  }

  Future<void> storeStudyLang(int userId, String lang, level) => _userDoc(userId).collection('languagePairs').add({
        'target_lang': lang,
        'level': level,
      });

  Future<void> setOnboarded(int userId, [bool isOnboarded = true]) => _userDoc(userId).update({
        'is_onboarded': isOnboarded,
      });

  Future<void> deleteUser(int userId) => _userDoc(userId).delete();
}

extension UserDaoExt on UserDao {
  DocumentReference _userDoc(int userId) => collection.document(userId.toString());
}
