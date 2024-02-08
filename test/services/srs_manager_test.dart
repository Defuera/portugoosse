import 'package:ai_assistant/ai_assistant.dart';
import 'package:database/database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portugoose/services/internal/srs_manager.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../utils/stubs.dart';

void main() {
  group('SrsManager', () {
    late SrsManager srsManager;
    late MockUserProgressDao mockUserProgressDao;
    late MockDeckManager mockDeckManager;

    setUp(() {
      mockUserProgressDao = MockUserProgressDao();
      mockDeckManager = MockDeckManager();
      srsManager = SrsManager(mockUserProgressDao, mockDeckManager, 20, 5);

      registerFallbackValue(stubUserProgressDto());
    });

    group('nextExercise', () {
      test('throws an exception when session is null', () async {
        print(stubSessionDto());
        when(() => mockUserProgressDao.get('1')).thenAnswer((_) => Future.value(null));

        expect(srsManager.nextExercise(1), throwsException);
      });

      test('returns the next exercise', () async {
        final session = stubSessionDto();
        when(() => mockUserProgressDao.get('1')).thenAnswer((_) => Future.value(stubUserProgressDto(session: session)));

        final result = await srsManager.nextExercise(1);
        expect(result, session.nextExercise);
      });
    });

    group('updateProgress', () {
      test('throws an exception when progress is null', () async {
        when(() => mockUserProgressDao.get('1')).thenAnswer((_) => Future.value(null));

        expect(srsManager.updateProgress(1, any(), Basket.again), throwsException);
      });

      test('throws an exception when session is null', () async {
        when(() => mockUserProgressDao.get('1')).thenAnswer((_) => Future.value(stubUserProgressDto(session: null)));

        expect(srsManager.updateProgress(1, 'word_0', Basket.again), throwsException);
      });

      test('updates the progress when evaluation is Basket.again', () async {
        final session = stubSessionDto();
        when(() => mockUserProgressDao.get('1')).thenAnswer((_) => Future.value(stubUserProgressDto(session: session)));
        when(() => mockUserProgressDao.set('1', any())).thenAnswer((_) => Future.value(null));

        final updatedSession = await srsManager.updateProgress(1, 'word_0', Basket.again);
        final againBasket = updatedSession.baskets[BasketDto.again]!;
        expect(againBasket.length, 20);
        expect(againBasket.first, 'word_1');
        expect(againBasket.last, 'word_0');
      });

      test('updates the progress when evaluation is Basket.hard', () async {
        final session = stubSessionDto();
        when(() => mockUserProgressDao.get('1')).thenAnswer((_) => Future.value(stubUserProgressDto(session: session)));
        when(() => mockUserProgressDao.set('1', any())).thenAnswer((_) => Future.value(null));

        final updatedSession = await srsManager.updateProgress(1, 'word_0', Basket.hard);
        final hardBasket = updatedSession.baskets[BasketDto.hard]!;
        expect(hardBasket.last, 'word_0');
        expect(hardBasket.length, 1);
        // also checking again basket
        final againBasket = updatedSession.baskets[BasketDto.again]!;
        expect(againBasket.length, 19);
        expect(againBasket.first, 'word_1');
      });

      // test several exercises in a row
      test('updates the progress when evaluation is Basket.hard', () async {
        srsManager = SrsManager(
          StubUserProgressDao(progress: stubUserProgressDto(session: stubSessionDto())),
          mockDeckManager,
          20,
          5,
        );

        final session = stubSessionDto();
        when(() => mockUserProgressDao.get('1')).thenAnswer((_) => Future.value(stubUserProgressDto(session: session)));
        when(() => mockUserProgressDao.set('1', any())).thenAnswer((_) => Future.value(null));

        // 1. Next exercise
        final exercise = await srsManager.nextExercise(1);
        // 2. Update progress
        await srsManager.updateProgress(1, exercise.key, Basket.hard);
        // 3. Next exercise
        final exercise2 = await srsManager.nextExercise(1);
        // 4. Update progress
        final progress = await srsManager.updateProgress(1, exercise2.key, Basket.easy);

        final baskets = progress.baskets;
        final againBasket = baskets[BasketDto.again]!;
        final hardBasket = baskets[BasketDto.hard]!;
        final goodBasket = baskets[BasketDto.good]!;
        final easyBasket = baskets[BasketDto.easy]!;
        expect(againBasket.length, 18);
        expect(hardBasket.length, 1);
        expect(goodBasket.length, 0);
        expect(easyBasket.length, 1);
      });
    });
  });
}
