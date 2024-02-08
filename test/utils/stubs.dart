import 'package:database/database.dart';
import 'package:firedart/firestore/models.dart';

SessionDto stubSessionDto({int countWords = 20}) {
  final words = List.generate(countWords, (index) => 'word_$index');
  return SessionDto(
    startTime: DateTime.now().millisecondsSinceEpoch,
    exercises: stubExercisesDto(words),
    baskets: {
      BasketDto.again: words,
      BasketDto.hard: [],
      BasketDto.good: [],
      BasketDto.easy: [],
    },
  );
}

ExercisesDto stubExercisesDto(List<String> words) {
  final exercises = Map.fromEntries(words.map((word) => MapEntry(word, 'phrase with word $word')));
  return exercises;
}

UserProgressDto stubUserProgressDto({SessionDto? session}) {
  return UserProgressDto(
    totalSessions: null,
    totalWordsReviewed: null,
    lastSessionAt: null,
    session: session,
    prevSession: null,
  );
}

class StubUserProgressDao implements UserProgressDao {
  StubUserProgressDao({UserProgressDto? progress}) : _progress = progress;

  UserProgressDto? _progress;

  @override
  CollectionReference get collection => throw UnimplementedError();

  @override
  Future<SessionDto?> getPrevSession(int userId) async => _progress?.prevSession;

  @override
  Future<SessionDto?> getSession(int userId) async => _progress?.session;

  @override
  Future<void> storeSession(int userId, SessionDto session) async {
    _progress = (_progress ?? UserProgressDto()).copyWith(session: session);
  }

  @override
  Future<UserProgressDto?> get(String userId) async => _progress;

  @override
  Future<void> set(String userId, UserProgressDto progress) async {
    _progress = progress;
  }
}
