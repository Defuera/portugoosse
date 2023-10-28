import 'dart:convert';

import 'package:ai_assistant/ai_assistant.dart';
import 'package:chatterbox/chatterbox.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:portugoose/config.dart';
import 'package:portugoose/flows/chat_image.dart';
import 'package:portugoose/flows/countdown_flow.dart';
import 'package:portugoose/flows/lesson_flow.dart';
import 'package:portugoose/flows/quiz_flow.dart';
import 'package:portugoose/flows/start.dart';
import 'package:portugoose/store_proxy.dart';
import 'package:shelf/shelf.dart';

final store = StoreProxy();

@CloudFunction()
Future<Response> function(Request request) async {
  try {
    await AiAssistant.init(Config.openAiApiKey);
    // var practiseFlow = PractiseFlow();
    final flows = <Flow>[
      StartFlow(),
      // practiseFlow,
      ChatImageFlow(),
      LessonFlow(),
      QuizFlow(),
      CountdownFlow(),
    ];

    Chatterbox(Config.botToken, flows, store).invokeFromWebhook(await parseRequestBody(request));
    return Response.ok(
      null,
      headers: {'Content-Type': 'application/json'},
    );
  } catch (error) {
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
