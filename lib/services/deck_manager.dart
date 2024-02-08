import 'package:portugoose/services/internal/dutch_words.dart';
import 'package:portugoose/services/internal/srs_manager.dart';

class DeckManager {
  Deck getUserDeck(String userId) {
    return defaultDutchDeck;
  }

  Deck get defaultDutchDeck {
    final json = dutchWords;

    final words = json.where((element) {
      return element['part_of_speech'] != '[article]';
    }).map(
      (element) => element['word'].toString(),
    );
    return Deck(words.toList());
  }
}
