import 'dart:math';

import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';
import 'package:collection/collection.dart';

class LessonFlow extends CommandFlow {
  @override
  String get command => 'image';

  @override
  List<StepFactory> get steps => [
        () => _LessonFlowInitialStep(),
        () => _LessonQuizStep(),
        () => _LessonQuizResponseStep(),
      ];

  static String uri = (_LessonFlowInitialStep).toStepUri();
}

class _LessonFlowInitialStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    print('LessonFlow');

    return ReactionResponse(
      text: 'Please choose a theme, that you want to study',
      buttons: ['Airport', 'Family', 'Food']
          .map((element) => InlineButton(
                title: element,
                nextStepUri: (_LessonQuizStep).toStepUri().appendArgs([element]),
              ))
          .toList(),
    );
  }
}

class _LessonQuizStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    print('_ThemeSelectionStep with args: $args');

    final topic = args?.firstOrNull;
    if (topic == null) {
      return ReactionResponse(text: 'Oops, something went wrong, please try again later');
    }

    final phrasesCount = 5;

    final phrasesResponse = await AiAssistant.instance.sendMessage(
      "I'm learning portuguese. Could you please generate $phrasesCount simple phrases for me to practise on topic $topic. Phrases should be 3 to 5 words. Put every phrase on a new line pls. Be short!",
    );
    if (phrasesResponse == null) {
      return ReactionResponse(text: "AI is being stupid. It couldn't generate content..");
    }
    print('phrasesResponse\n$phrasesResponse');

    final phrases = phrasesResponse.split('\n');

    final imageIndex = Random().nextInt(phrasesCount);

    final imageUrl = await AiAssistant.instance.createImage(phrases[imageIndex]);

    return ReactionResponse(
      text: "$imageUrl\nWhat is displayed on this image?",
      buttons: phrases
          .mapIndexed(
            (index, element) => InlineButton(
              title: element,
              nextStepUri: (_LessonQuizResponseStep).toStepUri().appendArgs(['${index == imageIndex}', topic]),
            ),
          )
          .toList(),
    );
  }
}

class _LessonQuizResponseStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    print('_LessonQuizResponseStep args\n$args');
    final success = args?.firstOrNull;
    if (success == null) {
      return ReactionResponse(text: 'Oops, something went wrong, please try again later');
    }

    final topic = args?[1];

    return ReactionResponse(text: 'You are ${success == 'true' ? "RIGHT" : "WRONG"}!\n\nOne more time?', buttons: [
      InlineButton(
        title: 'Yes!',
        nextStepUri: (_LessonQuizStep).toStepUri().appendArgs([topic ?? '']), //todo null
      ),
    ]);
  }
}
