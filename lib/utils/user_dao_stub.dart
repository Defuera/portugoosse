import 'package:database/database.dart';
import 'package:firedart/firestore/models.dart';

class UserDaoStub implements UserDao {
  UserDaoStub._();

  static UserDaoStub instance = UserDaoStub._();

  final store = <String, dynamic>{};

  @override
  CollectionReference get collection => throw UnimplementedError();

  @override
  Future<void> deleteUser(int userId) async {}

  @override
  Future<void> storeUserLocale(int userId, locale) async {
    store['locale'] = locale;
  }

  @override
  Future<String> getLocaleById(int userId) async {
    return store['locale'] ?? '';
  }

  @override
  Future<bool> isOnboarded(int userId) async {
    return store['is_onboarded'] ?? false;
  }

  userDoc(int userId) => store[userId.toString()];

  @override
  Future<void> setOnboarded(int userId, [bool isOnboarded = true]) async {
    store['is_onboarded'] = true;
  }

  @override
  Future<void> storeStudyLang(int userId, String lang, level) async {
    store['target_lang'] = lang;
    store['level'] = level;
  }

  @override
  getStudentData() {
    // TODO: implement getStudentData
    throw UnimplementedError();
  }
}
