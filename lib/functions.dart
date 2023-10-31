import 'dart:convert';

import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';
import 'package:database/database.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:portugoose/config.dart';
import 'package:portugoose/flows/exercises/lesson_flow.dart';
import 'package:portugoose/flows/exercises/phrase_learning_flow.dart';
import 'package:portugoose/flows/exercises/quiz_flow.dart';
import 'package:portugoose/flows/exercises/word_learning_flow.dart';
import 'package:portugoose/flows/generic/exercise_selection_menu.dart';
import 'package:portugoose/flows/generic/main_menu.dart';
import 'package:portugoose/flows/generic/onboarding_flow.dart';
import 'package:portugoose/flows/generic/start.dart';
import 'package:portugoose/flows/tests/chat_image.dart';
import 'package:portugoose/flows/tests/countdown_flow.dart';
import 'package:portugoose/store_proxy.dart';
import 'package:shelf/shelf.dart';

final store = StoreProxy();

@CloudFunction()
Future<Response> function(Request request) async {
  try {
    print('incoming message');
    Database.initialize();

    final body = await parseRequestBody(request);
    print('incoming message $body');
    await AiAssistant.init(Config.openAiApiKey);

    final userDao = Database.createUserDao();

    final flows = <Flow>[
      // Generic
      StartFlow(userDao),
      OnboardingFlow(userDao),
      ExerciseSelectionFlow(userDao),
      MainMenuFlow(userDao),

      // Lessons
      PhraseFlow(userDao),
      WordFlow(userDao),

      // Test
      ChatImageFlow(),
      LessonFlow(),
      CountdownFlow(),
    ];

    Chatterbox(Config.botToken, flows, store).invokeFromWebhook(body);
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
