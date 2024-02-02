import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';

class FirebaseStore implements PendingMessagesStore, ThreadStore {
  FirebaseStore(this.dao) : super();

  final DialogDao dao;

  @override
  Future<void> clearPending(int userId) => dao.clearPendingDialogUri(userId);

  @override
  Future<String?> retrievePending(int userId) => dao.retrievePendingDialogUri(userId);

  @override
  Future<void> setPending(int userId, String stepUrl) => dao.setPendingDialogUri(userId, stepUrl);

  @override
  Future<String?> getThreadId(String userId) => dao.getAssistantThreadId(userId);

  @override
  Future<void> setThreadId(String userId, String threadId) => dao.setAssistantThreadId(userId, threadId);
}
