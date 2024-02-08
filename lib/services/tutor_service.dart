import 'package:ai_assistant/ai_assistant.dart';
import 'package:database/database.dart';
import 'package:portugoose/services/internal/srs_manager.dart';
import 'package:portugoose/utils/logger.dart';

/// Every session user goes over 20 words
/// User should have at list 5 words in again basket
/// So if again basket has less then 5 words it'll be filled with new etries
///
///
/// Every word will be practised with 5 phrases
/// There must be at least 5 phrases on the stack, so users don't have to wait for the next phrase
///
class TutorService {
  TutorService(this.aiService, this.srsManager, this.userProgressDao);

  // final UserDao userDao;
  final UserProgressDao userProgressDao;
  final SrsManager srsManager;
  final AiService aiService;

  Future<SessionDto> createSession(int userId) async {
    logger.d('Create new session for user $userId');
    final prevSession = await userProgressDao.getPrevSession(userId);
    final words = await srsManager.newSet(userId, prevSession);

    final exercises = await aiService.getExercises(words);

    final session = SessionDto(
      startTime: DateTime.now().millisecondsSinceEpoch,
      exercises: exercises,
      baskets: {
        BasketDto.again: words,
        BasketDto.hard: [],
        BasketDto.good: [],
        BasketDto.easy: [],
      },
    );

    await userProgressDao.storeSession(userId, session);
    return session;
  }

  Future<MapEntry<String, String>> nextExercise(int userId) async {
    final session = await userProgressDao.getSession(userId);
    logger.d('Next exercise for $userId with session $session');
    if (session == null) {
      return throw Exception('Session is null');
    }

    return session.nextExercise;
  }

  Future<Evaluation> checkTranslation(int userId, String translation) async {
    final session = await userProgressDao.getSession(userId);
    logger.d('Check translation for user $userId with session $session');
    if (session == null) {
      return throw Exception('Session is null');
    }

    final exercise = session.nextExercise;
    final evaluation = await aiService.checkTranslation(userId.toString(), exercise, translation);
    if (evaluation == null) {
      return throw Exception('Evaluation is null');
    }

    await srsManager.updateProgress(userId, exercise.key, evaluation.basket);

    return evaluation;
  }

  Future<SessionDto?> getSession(int userId) {
    return userProgressDao.getSession(userId);
  }
}
