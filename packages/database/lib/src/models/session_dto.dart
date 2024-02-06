import 'package:database/database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_dto.freezed.dart';

part 'session_dto.g.dart';

@Freezed(toJson: true, fromJson: true)
class SessionDto with _$SessionDto {
  const factory SessionDto({
    required int startTime,
    int? endTime,
    required Map<BasketDto, List<String>> baskets,
  }) = _SessionDto;

  factory SessionDto.fromJson(Map<String, dynamic> json) => _$SessionDtoFromJson(json);
}

extension SessionDtoX on SessionDto {
  String get nextWord {
    final words = baskets.values.expand((element) => element).toList();
    return words.first;
  }

  bool get isCompleted {
    return baskets[BasketDto.again]!.isEmpty && baskets[BasketDto.hard]!.isEmpty;
  }

  //move word from current basket to given
  SessionDto update(BasketDto basket) {
    final word = nextWord;
    final updatedBaskets = baskets.map((key, value) {
      if (key == basket) {
        return MapEntry(key, value..add(word));
      } else {
        return MapEntry(key, value..remove(word));
      }
    });

    return copyWith(baskets: updatedBaskets);
  }
}
