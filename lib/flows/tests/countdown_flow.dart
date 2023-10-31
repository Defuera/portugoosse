import 'package:chatterbox/chatterbox.dart';

class CountdownFlow extends CommandFlow {
  @override
  String get command => 'countdown';

  @override
  List<StepFactory> get steps => [
        () => _CountdownFlowInitialStep(),
        () => _StartCountdownStep(),
        () => _UserResponseStep(),
      ];
}

class _CountdownFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: 'How much do you want to count down?',
      buttons: [
        InlineButton(title: '10', nextStepUri: (_StartCountdownStep).toStepUri().appendArgs(['10'])),
        InlineButton(title: '12', nextStepUri: (_StartCountdownStep).toStepUri().appendArgs(['12'])),
      ],
    );
  }
}

class _StartCountdownStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final number = (args?.firstOrNull ?? '100');

    return ReactionResponse(
      text: "Understood, let's start countdown from $number. Your turn, please start",
      // editMessageId: messageContext.editMessageId,
      afterReplyUri: (_UserResponseStep).toStepUri().appendArgs([number]),
    );
  }
}

class _UserResponseStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final userInput = messageContext.text;
    final number = (args?.firstOrNull ?? '100');

    if (userInput == number) {
      // bot turn to name a number, so I need to calculate the number, and then wait for user to name a new number
      final newNumber = int.parse(number) - 1;

      return ReactionResponse(
        text: "$newNumber",
        afterReplyUri: (_UserResponseStep).toStepUri().appendArgs(['${newNumber - 1}']),
      );
      // return ReactionForeignResponse(foreignUserId: foreignUserId, text: text)
    } else {
      return ReactionResponse(
        text: "Dude, this is a wrong number, please do again.",
        afterReplyUri: (_UserResponseStep).toStepUri().appendArgs([number]),
      );
    }
  }
}
