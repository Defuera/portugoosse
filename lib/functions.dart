import 'dart:convert';

import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:portugoose/config.dart';
import 'package:portugoose/flows/exercises/practice.dart';
import 'package:portugoose/flows/generic/onboarding_flow.dart';
import 'package:portugoose/flows/generic/start.dart';
import 'package:portugoose/services/deck_manager.dart';
import 'package:portugoose/services/internal/srs_manager.dart';
import 'package:portugoose/services/tutor_service.dart';
import 'package:portugoose/store/firebase_dialog_store.dart';
import 'package:shelf/shelf.dart';

const _wordsPerSession = 20;
const _newWordsPerSession = 5;

@CloudFunction()
Future<Response> function(Request request) async {
  try {
    print('incoming message url ${request.url}');

    final body = await parseRequestBody(request);
    print('incoming message $body');

    await Database.initialize();

    final deckManager = DeckManager();

    final userDao = Database.createUserDao();
    final dialogDao = Database.createDialogDao();
    final userProgressDao = Database.createUserProgressDao();
    final firebaseStore = FirebaseStore(dialogDao);
    final srsManager = SrsManager(userProgressDao, deckManager, _wordsPerSession, _newWordsPerSession);

    final aiService = AiService(Config.openAiApiKey, firebaseStore);
    final tutorService = TutorService(aiService, srsManager, userProgressDao);

    final flows = <Flow>[
      // Generic
      StartFlow(userDao, dialogDao),
      OnboardingFlow(userDao),

      // Lessons
      PractiseFlow(tutorService),
    ];

    Chatterbox(botToken: Config.botToken, flows: flows, store: firebaseStore).invokeFromWebhook(body);
    return Response.ok(
      null,
      headers: {'Content-Type': 'application/json'},
    );
  } catch (error, st) {
    print("I've crashed");
    print("$error");
    print(st.toString());
    return Response.ok(
      null,
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Map<String, dynamic>> parseRequestBody(Request request) async {
  final bodyBytes = await request.read().toList();
  final bodyString = utf8.decode(bodyBytes.expand((i) => i).toList());
  final jsonObject = jsonDecode(bodyString) as Map<String, dynamic>;

  return jsonObject;
}
