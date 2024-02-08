import 'package:ai_assistant/src/models/basket.dart';

class Evaluation {
  Evaluation(this.basket, this.explanation);

  final Basket basket;
  final String? explanation;

  static fromJson(Map<String, dynamic> data) => Evaluation(
        Basket.values.byName(data['evaluation'].toLowerCase()),
        data['explanation'],
      );
}
