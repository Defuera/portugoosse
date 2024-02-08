import 'package:ai_assistant/ai_assistant.dart';
import 'package:database/database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portugoose/services/tutor_service.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../utils/stubs.dart';

void main() {
  group('TutorService', () {
    late TutorService tutorService;
    late MockAiService mockAiService;
    late MockSrsManager mockSrsManager;
    late MockUserProgressDao mockUserProgressDao;

    setUp(() {
      mockAiService = MockAiService();
      mockSrsManager = MockSrsManager();
      mockUserProgressDao = MockUserProgressDao();
      tutorService = TutorService(mockAiService, mockSrsManager, mockUserProgressDao);
    });

    group('nextExercise', () {
      test('throws an exception when session is null', () async {
        when(() => mockUserProgressDao.getSession(1)).thenAnswer((_) => Future.value(null));

        expect(tutorService.nextExercise(1), throwsException);
      });

      test('returns the next exercise', () async {
        final session = stubSessionDto();
        when(() => mockUserProgressDao.getSession(1)).thenAnswer((_) => Future.value(session));

        final result = await tutorService.nextExercise(1);
        expect(result, session.nextExercise);
      });
    });

    //check translation
    group('checkTranslation', () {
      test('throws an exception when evaluation is null', () async {
        final session = stubSessionDto();
        when(() => mockUserProgressDao.getSession(1)).thenAnswer((_) => Future.value(session));
        when(() => mockAiService.checkTranslation('1', session.nextExercise, 'test'))
            .thenAnswer((_) => Future.value(null));

        expect(tutorService.checkTranslation(1, 'test'), throwsException);
      });

      test('updates the progress', () async {
        final session = stubSessionDto();
        when(() => mockUserProgressDao.getSession(1)).thenAnswer((_) => Future.value(session));
        when(() => mockAiService.checkTranslation('1', session.nextExercise, 'test'))
            .thenAnswer((_) => Future.value(Evaluation(Basket.again, null)));

        when(() => mockSrsManager.updateProgress(1, any(), Basket.again)).thenAnswer((_) => Future.value(session));

        await tutorService.checkTranslation(1, 'test');

        verify(() => mockSrsManager.updateProgress(1, any(), Basket.again));
      });
    });

    //integration test
    // 1. Create session
    // 2. Get next exercise
    // 3. Verify that the next exercise is not null
    // 4. Check translation
    // 5. Verify that the evaluation is not null and correct
    // 6. Verify that the progress is updated
    // 7. Get next exercise
    // 8. Verify that the next exercise is returned for expected word
  });



}
