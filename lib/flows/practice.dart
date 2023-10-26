import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';

class PractiseFlow extends Flow {
  @override
  List<StepFactory> get steps => [
        () => PractiseFlowInitialStep(),
      ];
}

class PractiseFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final aiAssistant = AiAssistant.instance;
    return ReactionResponse(text: aiAssistant.process(retrieveUserText(args)));
  }
}

String? retrieveUserText([List<String>? args]) {
  if (args != null) {
    final arguments = List<String>.from(args);
    final text = arguments.reduce((acc, word) => "$acc $word");
    return text;
  } else {
    return null;
  }
}
