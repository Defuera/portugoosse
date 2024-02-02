import 'package:ai_assistant/ai_assistant.dart';
import 'package:database/database.dart';
import 'package:portugoose/services/internal/dutch_words.dart';

/// Every session user goes over 20 words
/// User should have at list 5 words in again basket
/// So if again basket has less then 5 words it'll be filled with new etries
class TutorService {
  TutorService(this.aiService, this.userDao);

  final UserDao userDao;
  final AiService aiService;

  Future<String?> nextPhrase(int userId) async {
    final word = _nextWord(userId);
    return await aiService.nextPhrase(userId.toString(), word);
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

  String _nextWord(int userId) {
    final words = _loadWordsList();
    final word = words.first;
    return word;
  }

  Future<Evaluation?> checkTranslation(int userId, String translation) async {
    return await aiService.checkTranslation(userId.toString(), translation);
  }
}

// class Word {
//   final String dutch;
//   final String translation;
//
//   Word(this.dutch, this.translation);
// }
//
// class User {
//   final String id;
//   final String name;
//   final List<WordProgress> wordProgresses;
//
//   User(this.id, this.name, this.wordProgresses);
// }
//
// class WordProgress {
//   final Word word;
//   DateTime lastReviewed;
//   int reviewCount;
//   int interval;
//
//   WordProgress(this.word, this.lastReviewed, this.reviewCount, this.interval);
// }
//
// class SpacedRepetitionCalculator {
//   DateTime calculateNextReview(WordProgress wordProgress) {
//     // Define the base interval in days
//     int baseInterval = 1;
//
//     // Increase the interval every time the word is reviewed correctly
//     int newInterval = baseInterval * (wordProgress.reviewCount + 1);
//
//     // Calculate the next review date
//     DateTime nextReview = wordProgress.lastReviewed.add(Duration(days: newInterval));
//
//     return nextReview;
//   }
// }
//
// class WordRepository {
//   Future<Word> getWord(String id) {
//     // Implement your word retrieval logic here
//   }
// }
//
// class UserRepository {
//   Future<User> getUser(String id) {
//     // Implement your user retrieval logic here
//   }
// }
//
// class TutorService {
//   final UserRepository userRepository;
//   final WordRepository wordRepository;
//   final SpacedRepetitionCalculator calculator;
//
//   TutorService(this.userRepository, this.wordRepository, this.calculator);
//
//   Future<Word> getNextWord(String userId) async {
//     // Retrieve the User object for the given userId
//     User user = await userRepository.getUser(userId);
//
//     // Sort the WordProgress objects based on the lastReviewed date and the interval
//     user.wordProgresses.sort((a, b) {
//       DateTime nextReviewA = calculator.calculateNextReview(a);
//       DateTime nextReviewB = calculator.calculateNextReview(b);
//       return nextReviewA.compareTo(nextReviewB);
//     });
//
//     // Select the WordProgress object with the earliest next review date
//     WordProgress nextWordProgress = user.wordProgresses.first;
//
//     // Return the Word object associated with the selected WordProgress object
//     return nextWordProgress.word;
//   }
// }
