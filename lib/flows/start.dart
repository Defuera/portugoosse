import 'package:chatterbox/chatterbox.dart';

class StartFlow extends CommandFlow {
  StartFlow(this.practiseStepUri);

  final String practiseStepUri;

  @override
  String get command => 'start';

  @override
  List<StepFactory> get steps => [
        () => _InitialStep(practiseStepUri),
      ];
}

class _InitialStep extends FlowStep {
  _InitialStep(this.practiseStepUri);

  final String practiseStepUri;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: 'Welcome to portogosSe! Ready to start practicing?',
      buttons: [
        InlineButton(title: 'Letzz go', nextStepUri: practiseStepUri),
      ],
    );
  }
}
