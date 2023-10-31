import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';
import 'package:portugoose/flows/exercises/phrase_learning_flow.dart';
import 'package:portugoose/flows/exercises/word_learning_flow.dart';

class ExerciseSelectionFlow extends CommandFlow {
  ExerciseSelectionFlow(this.userDao);

  final UserDao userDao;

  @override
  String get command => 'start';

  @override
  List<StepFactory> get steps => [
        () => ExerciseSelectionFlowInitialStep(userDao),
      ];
}

class ExerciseSelectionFlowInitialStep extends FlowStep {
  ExerciseSelectionFlowInitialStep(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: 'Exercise!',
    );
  }
}
