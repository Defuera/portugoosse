import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';
import 'package:portugoose/utils/text_utils.dart';

class ChatImageFlow extends CommandFlow {
  @override
  String get command => 'image';

  @override
  List<StepFactory> get steps => [() => _ChatImageFlowInitialStep()];
}

class _ChatImageFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    print('ChatImageFlow');
    final prompt = retrieveUserText(args);
    if (prompt != null) {
      final imageUrl = await AiAssistant.instance.createImage(prompt);
      return ReactionResponse(text: 'Here\'s your image, buddy $imageUrl');
    } else {
      return ReactionResponse(text: 'I didn\'t get your prompt, sorry');
    }
  }
}
