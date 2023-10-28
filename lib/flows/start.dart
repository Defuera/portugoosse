import 'package:chatterbox/chatterbox.dart';
import 'package:portugoose/flows/lesson_flow.dart';
import 'package:portugoose/flows/quiz_flow.dart';

class StartFlow extends CommandFlow {
  @override
  String get command => 'start';

  @override
  List<StepFactory> get steps => [
        () => _StartFlowInitialStep(),
      ];
}

class _StartFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: 'Welcome to portogosSe! Do you want to start a lesson or do you want me to quiz you?',
      buttons: [
        InlineButton(title: 'A lesson', nextStepUri: LessonFlow.uri),
        // InlineButton(title: 'A quiz', nextStepUri: QuizFlow.uri),
      ],
    );
  }
}
