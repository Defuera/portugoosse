import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';
import 'package:portugoose/flows/generic/exercise_selection_menu.dart';
import 'package:portugoose/flows/generic/onboarding_flow.dart';

class StartFlow extends CommandFlow {
  StartFlow(this.userDao);

  final UserDao userDao;

  @override
  String get command => 'start';

  @override
  List<StepFactory> get steps => [
        () => _StartFlowInitialStep(userDao),
      ];
}

class _StartFlowInitialStep extends FlowStep {
  _StartFlowInitialStep(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final isOnboarded = await userDao.isOnboarded(messageContext.userId);
    print('isOnboarded $isOnboarded');
    if (isOnboarded) {
      return ReactionRedirect(stepUri: (ExerciseSelectionFlowInitialStep).toStepUri());
    } else {
      return ReactionRedirect(stepUri: (OnboardingFlowInitialStep).toStepUri());
    }
  }
}
