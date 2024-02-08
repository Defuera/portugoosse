// import 'package:ai_assistant/ai_assistant.dart';
// import 'package:database/database.dart';
import 'package:ai_assistant/ai_assistant.dart';
import 'package:database/database.dart';
import 'package:portugoose/services/deck_manager.dart';
import 'package:portugoose/utils/model_converters.dart';

/// Every session user goes over 20 words
/// User should have at list 5 words in again basket
/// So if again basket has less then 5 words it'll be filled with new etries
///
///
/// Every word will be practised with 5 phrases
/// There must be at least 5 phrases on the stack, so users don't have to wait for the next phrase
///
///
/// Operates only on words has no knowledge of phrases
class SrsManager {
  SrsManager(
    this.userProgressDao,
    this.deckManager,
    this.wordsPerSession,
    this.newWordsPerSession,
  );

  final UserProgressDao userProgressDao;
  final DeckManager deckManager;
  final int wordsPerSession;
  final int newWordsPerSession;

  Future<MapEntry<String, String>> nextExercise(int userId) async {
    final progress = await userProgressDao.get(userId.toString());
    final session = progress?.session;
    if (session == null) {
      throw Exception('Illegal State Exception: Session is null');
    }

    return session.nextExercise;
  }

  Future<SessionDto> updateProgress(int userId, String word, Basket basket) async {
    final progress = await userProgressDao.get(userId.toString());
    final session = progress?.session;

    if (progress == null || session == null) {
      throw Exception('Illegal State Exception: Session is null');
    }

    final updatedSession = session.update(word, basket.toDto);
    await userProgressDao.set(userId.toString(), progress.copyWith(session: updatedSession));

    return updatedSession;
  }

  /// Returns set of words to learn in the next session
  Future<List<String>> newSet(int userId, SessionDto? prevSession) async {
    final words = deckManager.getUserDeck(userId.toString()).words;
    if (prevSession != null) {
      final againWords = prevSession.baskets[BasketDto.again]!;
      final newWords = words.where((element) => !againWords.contains(element)).toList();
      final newWordsToAdd = newWords.sublist(0, newWordsPerSession);
      words.addAll(newWordsToAdd);
    }

    return words.sublist(0, wordsPerSession);
  }
}

class Deck {
  Deck(this.words);

  final List<String> words;
}
