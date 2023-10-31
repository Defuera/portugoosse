import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';
import 'package:portugoose/flows/generic/onboarding_flow.dart';

class MainMenuFlow extends CommandFlow {
  MainMenuFlow(this.userDao);

  final UserDao userDao;

  @override
  String get command => 'start';

  @override
  List<StepFactory> get steps => [
        () => _MainMenuFlowInitialStep(userDao),
      ];
}

class _MainMenuFlowInitialStep extends FlowStep {
  _MainMenuFlowInitialStep(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    if (await userDao.isOnboarded(messageContext.userId)) {
      return ReactionRedirect(stepUri: (OnboardingFlowInitialStep).toStepUri());
    } else {}

    return ReactionResponse(
      text: 'Todo',
      buttons: [
        // InlineButton(title: 'A lesson', nextStepUri: LessonFlow.uri),
        // InlineButton(title: 'A quiz', nextStepUri: QuizFlow.uri),
      ],
    );
  }
}
