import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';
import 'package:portugoose/utils/text_utils.dart';

class QuizFlow extends Flow {
  static String uri = (_QuizFlowInitialStep).toStepUri();

  @override
  List<StepFactory> get steps => [() => _QuizFlowInitialStep()];
}

class _QuizFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    print('QuizFlow');
    final prompt = retrieveUserText(args);
    if (prompt != null) {
      final imageUrl = await AiAssistant.instance.createImage(prompt);
      return ReactionResponse(text: 'Here\'s your image, buddy $imageUrl');
    } else {
      return ReactionResponse(text: 'I didn\'t get your prompt, sorry');
    }
  }
}
