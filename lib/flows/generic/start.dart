import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';
import 'package:portugoose/flows/exercises/practice.dart';
import 'package:portugoose/flows/generic/onboarding_flow.dart';

class StartFlow extends CommandFlow {
  StartFlow(this.userDao, this.dialogDao);

  final UserDao userDao;
  final DialogDao dialogDao;

  @override
  String get command => 'start';

  @override
  List<StepFactory> get steps => [
        () => _StartFlowInitialStep(userDao, dialogDao),
      ];
}

class _StartFlowInitialStep extends FlowStep {
  _StartFlowInitialStep(this.userDao, this.dialogDao);

  final UserDao userDao;
  final DialogDao dialogDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final userId = messageContext.userId;
    final isOnboarded = await userDao.isOnboarded(userId);
    print('isOnboarded $isOnboarded');
    if (isOnboarded) {
      dialogDao.clearAssistantThreadId(userId.toString());
      return ReactionRedirect(stepUri: (PractiseFlowInitialStep).toStepUri());
    } else {
      return ReactionRedirect(stepUri: (OnboardingFlowInitialStep).toStepUri());
    }
  }
}
