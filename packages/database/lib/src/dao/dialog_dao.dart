import 'package:database/src/utils/document_extensions.dart';
import 'package:firedart/firedart.dart';

const _collectionName = "dialogs";

class DialogDao {
  DialogDao(this._firestore);

  final Firestore _firestore;

  CollectionReference get collection => _firestore.collection(_collectionName);

  Future<String?> retrievePendingDialogUri(int userId) async {
    final stepId = await collection.document('$userId').getFieldSafe('pending_step_url');
    if (stepId != null) {
      await clearPendingDialogUri(userId);
    }
    return stepId;
  }

  Future<void> setPendingDialogUri(int userId, String stepUrl) {

    return collection.document('$userId').update({
        'pending_step_url': stepUrl,
      });
  }

  Future<void> clearPendingDialogUri(int userId) => collection.document('$userId').update({
        "pending_step_url": null,
      });

  Future<String?> getAssistantThreadId(String userId) =>
      collection.document(userId).getFieldSafe('assistant_thread_id');

  Future<void> clearAssistantThreadId(String userId) => collection.document(userId).update({
    'assistant_thread_id': null,
  });

  Future<void> setAssistantThreadId(String userId, String threadId) => collection.document(userId).update({
        'assistant_thread_id': threadId,
      });
}
