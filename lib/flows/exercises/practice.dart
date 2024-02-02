import 'package:chatterbox/chatterbox.dart';
import 'package:portugoose/services/tutor_service.dart';

/// Practice works in following way:
/// 1. Retrieve user histrory
/// 2. If user does not have a history send him first phrase
///

// MVP
// User can practise one of the supported languages
// User can start practise and will get phrases to translate.
class PractiseFlow extends Flow {
  PractiseFlow(this.tutor);

  final TutorService tutor;

  @override
  List<StepFactory> get steps => [
        () => PractiseFlowInitialStep(tutor),
        () => _CheckUserTranslationStep(tutor),
        () => _PracticeCompleteStep(),
      ];
}

class PractiseFlowInitialStep extends FlowStep {
  PractiseFlowInitialStep(this.tutor);

  final TutorService tutor;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    try {
      final userId = messageContext.userId;
      final phrase = await tutor.nextPhrase(userId);

      if (phrase == null) {
        return ReactionResponse(
          text: 'Something went wrong, null phrase is returned',
        );
      }

      return ReactionResponse(
        text: phrase,
        afterReplyUri: (_CheckUserTranslationStep).toStepUri(),
      );
    } catch (error) {
      return ReactionResponse(
        text: 'Something went wrong\n\n$error',
      );
    }
  }
}

class _CheckUserTranslationStep extends FlowStep {
  _CheckUserTranslationStep(this.tutor);

  final TutorService tutor;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final userId = messageContext.userId;
    final translation = messageContext.text;

    if (translation == null) {
      return ReactionResponse(
        text: 'Please provide a translation',
      );
    }

    final evaluation = await tutor.checkTranslation(userId, translation);

    if (evaluation == null) {
      return ReactionResponse(
        text: 'Something went wrong',
      );
    }

    return ReactionResponse(
      text: 'You did ${evaluation.evaluation}.\n${evaluation.explanation}\n\nReady for next one?',
      buttons: [
        InlineButton(
          title: 'Yes',
          nextStepUri: (PractiseFlowInitialStep).toStepUri(),
        ),
        InlineButton(
          title: 'No',
          nextStepUri: (_PracticeCompleteStep).toStepUri(),
        ),
      ],
    );
  }
}

class _PracticeCompleteStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: 'Alright, good job. Send /start command when you are up for the next session',
    );
  }
}
