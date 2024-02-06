import 'package:ai_assistant/ai_assistant.dart';
import 'package:database/database.dart';
import 'package:portugoose/services/internal/dutch_words.dart';
import 'package:portugoose/services/internal/extensions.dart';

/// Every session user goes over 20 words
/// User should have at list 5 words in again basket
/// So if again basket has less then 5 words it'll be filled with new etries
///
///
/// Every word will be practised with 5 phrases
/// There must be at least 5 phrases on the stack, so users don't have to wait for the next phrase
///
class SrsManager {
  SrsManager(this.userProgressDao);

  final UserProgressDao userProgressDao;

  Future<String> nextWord(int userId) async {
    final progress = await userProgressDao.get(userId.toString());
    if (progress == null) {
      final session = _createSession();
      await userProgressDao.set(
          userId.toString(),
          UserProgressDto(
            totalSessions: 1,
            totalWordsReviewed: 0,
            lastSessionAt: DateTime.now().millisecondsSinceEpoch,
            session: session,
          ));

      return session.nextWord;
    }

    return progress.session.nextWord;
  }

  Future<void> updateProgress(int userId, Basket basket) async {
    final progress = await userProgressDao.get(userId.toString());
    final session = progress?.session;

    if (progress == null || session == null) {
      throw Exception('Illegal State Exception: Session is null');
    }

    final updatedSession = session.update(basket.toDto);
    await userProgressDao.set(userId.toString(), progress.copyWith(session: updatedSession));
  }

  /// Again Basket is filled with 20 words
  /// Each practice session is 20 words
  /// When new sessions starts 5 new words are added to the again basket and mixed with the words from the previous session
  SessionDto _createSession([SessionDto? prevSession]) {
    final words = _loadWordsList();
    if (prevSession != null) {
      final againWords = prevSession.baskets[BasketDto.again]!;
      final newWords = words.where((element) => !againWords.contains(element)).toList();
      final newWordsToAdd = newWords.sublist(0, 5);
      words.addAll(newWordsToAdd);
    }
    final session = SessionDto(
      startTime: DateTime.now().millisecondsSinceEpoch,
      baskets: {
        BasketDto.again: words.sublist(0, 20),
        BasketDto.hard: [],
        BasketDto.good: [],
        BasketDto.easy: [],
      },
    );

    return session;
  }

  List<String> _loadWordsList() {
    final json = dutchWords;

    final words = json.where((element) {
      return element['part_of_speech'] != '[article]';
    }).map(
      (element) => element['word'].toString(),
    );
    return words.toList();
  }
}
