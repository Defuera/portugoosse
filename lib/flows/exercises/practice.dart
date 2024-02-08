import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';
import 'package:portugoose/flows/exercises/internal/extensions.dart';
import 'package:portugoose/services/tutor_service.dart';
import 'package:portugoose/utils/logger.dart';

/// Practice works in following way:
/// 1. Retrieve user history
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
        () => _NewSessionStep(),
        () => _ExerciseStep(tutor),
        () => _CheckUserTranslationStep(tutor),
        () => _PracticeCompleteStep(),
      ];
}

class PractiseFlowInitialStep extends FlowStep {
  PractiseFlowInitialStep(this.tutor);

  final TutorService tutor;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final session = await tutor.getSession(messageContext.userId);
    if (session == null) {
      await tutor.createSession(messageContext.userId);
      return ReactionRedirect(stepUri: (_NewSessionStep).toStepUri());
    } else {
      return ReactionRedirect(stepUri: (_ExerciseStep).toStepUri());
    }
  }
}

class _NewSessionStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionComposed(responses: [
      ReactionResponse(
        text: 'Let\'s start a new session',
      ),
      ReactionRedirect(stepUri: (_ExerciseStep).toStepUri()),
    ]);
  }
}

class _ExerciseStep extends FlowStep {
  _ExerciseStep(this.tutor);

  final TutorService tutor;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    try {
      final userId = messageContext.userId;
      final exercise = await tutor.nextExercise(userId);

      final markdown = exercise.toMarkdown;
      logger.d('Exercise markdown: $markdown');
      return ReactionResponse(
        text: markdown,
        markdown: true,
        afterReplyUri: (_CheckUserTranslationStep).toStepUri(),
      );
    } catch (error, stackTrace) {
      logger.e('Error while checking translation', error: error, stackTrace: stackTrace);
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

    try {
      final evaluation = await tutor.checkTranslation(userId, translation);

      final grade = _gradeEvaluation(evaluation.basket);
      final additionalText = evaluation.explanation != null ? '\n${evaluation.explanation}' : '';

      return ReactionComposed(responses: [
        ReactionResponse(
          text: 'You did $grade!$additionalText',
        ),
        ReactionRedirect(stepUri: (_ExerciseStep).toStepUri()),
      ]);
    } catch (error, stackTrace) {
      logger.e('Error while checking translation', error: error, stackTrace: stackTrace);
      return ReactionResponse(
        text: 'Something went wrong\n\n$error',
      );
    }
  }

  String _gradeEvaluation(Basket basket) => switch (basket) {
        Basket.again => 'bad',
        Basket.hard => 'not so good',
        Basket.good => 'good',
        Basket.easy => 'excellent',
      };
}

class _PracticeCompleteStep extends FlowStep {
  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: 'Alright, good job. Send /start command when you are up for the next session',
    );
  }
}
