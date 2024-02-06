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

  Future<void> setNewSession(String string, SessionDto session) {
    return collection.document(string).update(
      {'session': session.toJson()},
    );
  }

  Future<void> set(String userId, UserProgressDto progress) {
    final json = progress.toJson();
    return collection.document(userId).set(json);
  }
}
