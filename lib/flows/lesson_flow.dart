import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';

class LessonFlow extends CommandFlow {
  @override
  String get command => 'image';

  @override
  List<StepFactory> get steps => [
        () => _LessonFlowInitialStep(),
        () => _ThemeSelectionStep(),
      ];

  static String uri = (_LessonFlowInitialStep).toStepUri();
}

class _LessonFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    print('LessonFlow');

    return ReactionResponse(
      text: 'Please choose a theme, that you want to study',
      buttons: ['Airport', 'Family', 'Greetings']
          .map((element) => InlineButton(
                title: element,
                nextStepUri: (_ThemeSelectionStep).toStepUri().appendArgs([element]),
              ))
          .toList(),
    );
  }
}

class _ThemeSelectionStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    print('_ThemeSelectionStep with args: $args');

    AiAssistant.instance.sendMessage('please generate a simple phrase of ');

    return ReactionResponse(
      text: "You've selected ${args?.firstOrNull ?? 'no'} theme!",
    );
  }
}
