import 'package:ai_assistant/ai_assistant.dart';
import 'package:database/database.dart';

extension BasketX on Basket {
  BasketDto get toDto {
    switch (this) {
      case Basket.again:
        return BasketDto.again;
      case Basket.hard:
        return BasketDto.hard;
      case Basket.good:
        return BasketDto.good;
      case Basket.easy:
        return BasketDto.easy;
    }
  }
}

extension ExerciseX on Exercises {
  ExercisesDto get toDto => this;
}

extension ListExerciseX on List<Exercises> {
  List<ExercisesDto> get toDto {
    return map((e) => e.toDto).toList();
  }
}
