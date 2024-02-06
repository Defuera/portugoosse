import 'package:ai_assistant/ai_assistant.dart';
import 'package:database/database.dart';
import 'package:portugoose/services/internal/srs_manager.dart';

/// Every session user goes over 20 words
/// User should have at list 5 words in again basket
/// So if again basket has less then 5 words it'll be filled with new etries
///
///
/// Every word will be practised with 5 phrases
/// There must be at least 5 phrases on the stack, so users don't have to wait for the next phrase
///
class TutorService {
  TutorService(this.aiService, this.srsManager, this.userDao);

  final UserDao userDao;
  final SrsManager srsManager;
  final AiService aiService;

  /// User starts with empty baskets
  /// Again Basket is filled with 20 words
  /// User iterates over the words and words are moved to baskets according to evaluation
  /// Each practice session is 20 words
  /// Session lasts until there's no words in the again or hard baskets
  /// When new sessions starts 5 new words are added to the again basket and mixed with the words from the previous session
  Future<String?> nextPhrases(int userId) async {
    final word = await srsManager.nextWord(userId);
    return await aiService.nextPhrase(userId.toString(), word);
  }

  Future<Evaluation> checkTranslation(int userId, String translation) async {
    final evaluation = await aiService.checkTranslation(userId.toString(), translation);
    if (evaluation == null) {
      return throw Exception('Evaluation is null');
    }

    await srsManager.updateProgress(userId, evaluation.basket);

    return evaluation;
  }
}
