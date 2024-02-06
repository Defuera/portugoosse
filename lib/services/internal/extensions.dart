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
