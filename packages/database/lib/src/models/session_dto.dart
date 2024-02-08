import 'package:database/database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_dto.freezed.dart';

part 'session_dto.g.dart';

@Freezed(toJson: true, fromJson: true)
class SessionDto with _$SessionDto {
  const SessionDto._();

  const factory SessionDto({
    required int startTime,
    int? endTime,
    required Map<BasketDto, List<String>> baskets,
    required ExercisesDto exercises,
  }) = _SessionDto;

  factory SessionDto.fromJson(Map<String, dynamic> json) => _$SessionDtoFromJson(json);

  @override
  String toString() => """Session{
  again: ${baskets[BasketDto.again]!},
  hard: ${baskets[BasketDto.hard]!},
  good: ${baskets[BasketDto.good]!},
  easy: ${baskets[BasketDto.easy]!},
  nextWord: $nextWord,
}""";
}

extension SessionDtoX on SessionDto {
  String get nextWord => orderedWords.first;

  /// Returns list of words in the order of baskets from the hardest to the easiest
  List<String> get orderedWords => [
        ...baskets[BasketDto.again]!,
        ...baskets[BasketDto.hard]!,
        ...baskets[BasketDto.good]!,
        ...baskets[BasketDto.easy]!,
      ];

  MapEntry<String, String> get nextExercise => exercises.entries.firstWhere((element) => nextWord == element.key);

  bool get isCompleted {
    return baskets[BasketDto.again]!.isEmpty && baskets[BasketDto.hard]!.isEmpty;
  }

  /// Moves given word from current basket to given one
  SessionDto update(String word, BasketDto basket) {
    final updatedBaskets = baskets.map((key, value) {
      if (key == basket) {
        return MapEntry(
            key,
            value
              ..remove(word)
              ..add(word));
      } else {
        return MapEntry(key, value..remove(word));
      }
    });

    return copyWith(baskets: updatedBaskets);
  }
}
