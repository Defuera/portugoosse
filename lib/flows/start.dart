import 'package:chatterbox/chatterbox.dart';

class StartFlow extends CommandFlow {
  @override
  String get command => 'start';

  @override
  List<StepFactory> get steps => [
        () => _InitialStep(),
      ];
}

class _InitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: 'Welcome to portogosSe! What topic do you want to discuss today?',
      buttons: [
        InlineButton(title: 'Introduction', nextStepUri: 'intro'),
      ],
    );
  }
}
