import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';
import 'package:portugoose/flows/generic/onboarding_flow.dart';
import 'package:portugoose/flows/exercises/lesson_flow.dart';

class PhraseFlow extends CommandFlow {
  PhraseFlow(this.userDao);

  final UserDao userDao;

  @override
  String get command => 'start';

  @override
  List<StepFactory> get steps => [
        () => PhraseLearningFlowInitialStep(userDao),
  ];
}

class PhraseLearningFlowInitialStep extends FlowStep {
  PhraseLearningFlowInitialStep(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    if (await userDao.isOnboarded(messageContext.userId)) {
      return ReactionRedirect(stepUri: (OnboardingFlowInitialStep).toStepUri());
    } else {

    }

    return ReactionResponse(
      text: 'Welcome to Portogoose! Do you want to start a lesson or do you want me to quiz you?',
      buttons: [
        InlineButton(title: 'A lesson', nextStepUri: LessonFlow.uri),
        // InlineButton(title: 'A quiz', nextStepUri: QuizFlow.uri),
      ],
    );
  }
}
