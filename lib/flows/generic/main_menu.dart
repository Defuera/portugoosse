import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';
import 'package:portugoose/flows/generic/onboarding_flow.dart';

class MainMenuFlow extends CommandFlow {
  MainMenuFlow(this.userDao);

  final UserDao userDao;

  @override
  String get command => 'menu';

  @override
  List<StepFactory> get steps => [
        () => _MainMenuFlowInitialStep(),
        () => _OnResetOnboarding(userDao),
        () => _OnMenuQuit(),
      ];
}

class _MainMenuFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: 'For now you can only redo onboarding here, wanna?',
      buttons: [
        InlineButton(title: 'Reset onboarding', nextStepUri: (_OnResetOnboarding).toStepUri()),
        InlineButton(title: 'Quit', nextStepUri: (_OnMenuQuit).toStepUri()),
      ],
    );
  }
}

class _OnResetOnboarding extends FlowStep {
  _OnResetOnboarding(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    await userDao.deleteUser(messageContext.userId);
    return ReactionRedirect(
      editMessageId: messageContext.editMessageId,
      stepUri: (OnboardingFlowInitialStep).toStepUri(),
    );
  }
}

class _OnMenuQuit extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: '😊',
      editMessageId: messageContext.editMessageId,
    );
  }
}
