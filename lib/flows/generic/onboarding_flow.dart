import 'package:chatterbox/chatterbox.dart';
import 'package:collection/collection.dart';
import 'package:database/database.dart';
import 'package:portugoose/flows/generic/exercise_selection_menu.dart';
import 'package:portugoose/lessons/constants.dart';

class OnboardingFlow extends Flow {
  OnboardingFlow(this.userDao);

  final UserDao userDao;

  @override
  List<StepFactory> get steps => [
        () => OnboardingFlowInitialStep(userDao),
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
    return ReactionResponse(
      text: '''
        🪿 Welcome to Portugoose! 
      
        🤖 Chat with AI for real-world language practice.
        📆 Benefit from smart spaced repetition for lasting memory.
        🌍 Dive into immersive learning with ALG.
        🤳 Use our Telegram bot for easy access.

        \nLet's start by selecting your native language
        ''',
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
      buttons: studyLangToCodeMap.toButtons(
        title: (entry) => entry.key,
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
      buttons: langLevelToDescriptionMap.toButtons(
        title: (entry) => '${entry.key} ${entry.value}',
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
      ),
      ReactionRedirect(stepUri: (ExerciseSelectionFlowInitialStep).toStepUri()),
    ]);
  }
}

extension MapExt on Map<String, String> {
  List<InlineButton> toButtons({
    required String Function(MapEntry) title,
    List<String>? Function(MapEntry)? args,
  }) =>
      entries
          .map(
            (entry) => InlineButton(
              title: title(entry),
              nextStepUri: (_LevelSelectedStep).toStepUri(args?.call(entry)),
            ),
          )
          .toList();
}
