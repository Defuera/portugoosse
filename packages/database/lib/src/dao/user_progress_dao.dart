import 'package:database/src/models/session_dto.dart';
import 'package:database/src/models/user_progress_dto.dart';
import 'package:database/src/utils/document_extensions.dart';
import 'package:firedart/firedart.dart';

const _collectionName = "progress";

class UserProgressDao {
  UserProgressDao(this._firestore);

  final Firestore _firestore;

  CollectionReference get collection => _firestore.collection(_collectionName);

  Future<UserProgressDto?> get(String userId) async {
    final doc = await collection.document(userId).getSafe();
    if (doc != null) {
      return UserProgressDto.fromJson(doc.map);
    }
    return null;
  }

  Future<void> set(String userId, UserProgressDto progress) {
    final json = progress.toJson();
    return collection.document(userId).set(json);
  }

  Future<SessionDto?> getSession(int userId) => _parse(userId, "session", SessionDto.fromJson);

  Future<SessionDto?> getPrevSession(int userId) => _parse(userId, "prevSession", SessionDto.fromJson);

  Future<void> storeSession(int userId, SessionDto session) {
    return _userDoc(userId).update({
      "session": session.toJson(),
    });
  }
}

extension _UserProgressDaoExt on UserProgressDao {
  DocumentReference _userDoc(int userId) => collection.document(userId.toString());

  Future<T?> _parse<T>(int userId, String fieldName, T Function(Map<String, dynamic>) converter) async {
    final data = await _userDoc(userId).getFieldSafe(fieldName);
    if (data == null) {
      return null;
    }
    return converter(data);
  }
}
