import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';
import 'package:portugoose/flows/exercises/phrase_learning_flow.dart';
import 'package:portugoose/flows/exercises/word_learning_flow.dart';

class ExerciseSelectionFlow extends Flow {
  ExerciseSelectionFlow(this.userDao);

  final UserDao userDao;

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
    return ReactionResponse(text: 'Portugoose offers different ways of practicing a language!', buttons: [
      InlineButton(title: 'Learn words', nextStepUri: (WordLearningFlowInitialStep).toStepUri()),
      InlineButton(title: 'Learn phrases', nextStepUri: (PhraseLearningFlowInitialStep).toStepUri()),
    ]);
  }
}
