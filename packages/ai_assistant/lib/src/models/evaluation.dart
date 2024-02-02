
import 'package:ai_assistant/src/models/basket.dart';

class Evaluation {
  Evaluation(this.evaluation, this.explanation);

  final Basket evaluation;
  final String? explanation;

  static fromJson(Map<String, dynamic> data) => Evaluation(
        Basket.values.byName(data['evaluation'].toLowerCase()),
        data['explanation'],
      );
}
