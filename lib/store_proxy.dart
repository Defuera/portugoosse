import 'package:chatterbox/chatterbox.dart';

class StoreProxy extends ChatterboxStore {
  @override
  Future<void> clearPending(int userId) async {}

  @override
  Future<String?> retrievePending(int userId) async {
    return null;
  }

  @override
  Future<void> setPending(int userId, String stepUrl) async {}
}
