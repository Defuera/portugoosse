import 'package:chatterbox/chatterbox.dart';
import 'package:collection/collection.dart';
import 'package:database/database.dart';
import 'package:portugoose/flows/exercises/practice.dart';
import 'package:portugoose/lessons/constants.dart';

class OnboardingFlow extends Flow {
  OnboardingFlow(this.userDao);

  final UserDao userDao;

  @override
  List<StepFactory> get steps => [
        () => OnboardingFlowInitialStep(userDao),
        () => _SelectUserLocale(userDao),
        () => _UserLanguageSelectedStep(userDao),
        () => _StudyLanguageSelectedStep(userDao),
        () => _LevelSelectedStep(userDao),
        () => _OnboardingCompleteStep(userDao),
      ];
}

class OnboardingFlowInitialStep extends FlowStep {
  OnboardingFlowInitialStep(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionComposed(responses: [
      ReactionResponse(
        text: '''
        🪿 Welcome to Portugoose! 
      
        🤖 Chat with AI for real-world language practice.
        📆 Benefit from smart spaced repetition for lasting memory.
        🌍 Dive into immersive learning with ALG.
        🤳 Use our Telegram bot for easy access.
        ''',
      ),
      ReactionRedirect(stepUri: (_SelectUserLocale).toStepUri()),
    ]);
  }
}

class _SelectUserLocale extends FlowStep {
  _SelectUserLocale(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    return ReactionResponse(
      text: "Let's start by selecting your native language",
      buttons: [
        // InlineButton(title: 'Russian', nextStepUri: (_UserLanguageSelectedStep).toStepUri(['ru'])),
        InlineButton(title: 'English', nextStepUri: (_UserLanguageSelectedStep).toStepUri(['en'])),
      ],
    );
  }
}

class _UserLanguageSelectedStep extends FlowStep {
  _UserLanguageSelectedStep(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final lang = args?.firstOrNull;

    if (lang == null) {
      return ReactionComposed(responses: [
        ReactionResponse(
          text: 'Something went wrong, please try again',
        ),
        ReactionRedirect(stepUri: (OnboardingFlowInitialStep).toStepUri()),
      ]);
    }

    await userDao.storeUserLocale(messageContext.userId, lang);
    return ReactionResponse(
      text: 'And what language do you want to learn now?',
      // editMessageId: messageContext.editMessageId,
      buttons: studyLangToCodeMap.toButtons(
        title: (entry) => entry.key,
        step: (_StudyLanguageSelectedStep),
        args: (entry) => [entry.value],
      ),
    );
  }
}

class _StudyLanguageSelectedStep extends FlowStep {
  _StudyLanguageSelectedStep(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final lang = args?.firstOrNull;

    if (lang == null) {
      return ReactionComposed(responses: [
        ReactionResponse(
          text: 'Something went wrong, please try again',
        ),
        ReactionRedirect(stepUri: (OnboardingFlowInitialStep).toStepUri()),
      ]);
    }

    return ReactionResponse(
      text: "What level do you want to practice?",
      editMessageId: messageContext.editMessageId,
      buttons: langLevelToDescriptionMap.toButtons(
        title: (entry) => '${entry.key} ${entry.value}',
        step: (_LevelSelectedStep),
        args: (entry) => [lang, entry.key],
      ),
    );
  }
}

class _LevelSelectedStep extends FlowStep {
  _LevelSelectedStep(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    final level = args?.removeLast();
    final lang = args?.firstOrNull;

    if (level == null || lang == null) {
      return ReactionComposed(responses: [
        ReactionResponse(
          text: 'Something went wrong, please try again',
        ),
        ReactionRedirect(stepUri: (OnboardingFlowInitialStep).toStepUri()),
      ]);
    }

    await userDao.storeStudyLang(messageContext.userId, lang, level);

    return ReactionRedirect(stepUri: (_OnboardingCompleteStep).toStepUri());
  }
}

class _OnboardingCompleteStep extends FlowStep {
  _OnboardingCompleteStep(this.userDao);

  final UserDao userDao;

  @override
  Future<Reaction> handle(MessageContext messageContext, [List<String>? args]) async {
    await userDao.setOnboarded(messageContext.userId);

    return ReactionComposed(responses: [
      ReactionResponse(
        text: "Ok we are all set! Let's start with exercise selection.",
        editMessageId: messageContext.editMessageId,
      ),
      ReactionRedirect(stepUri: (PractiseFlowInitialStep).toStepUri()),
    ]);
  }
}

extension MapExt on Map<String, String> {
  List<InlineButton> toButtons({
    required String Function(MapEntry) title,
    List<String>? Function(MapEntry)? args,
    required Type step,
  }) =>
      entries
          .map(
            (entry) => InlineButton(
              title: title(entry),
              nextStepUri: step.toStepUri(args?.call(entry)),
            ),
          )
          .toList();
}
