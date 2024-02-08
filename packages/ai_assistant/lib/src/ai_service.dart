import 'dart:convert';

import 'package:ai_assistant/src/assistant/assistant_api.dart';
import 'package:ai_assistant/src/assistant/thread_store.dart';
import 'package:ai_assistant/src/models/evaluation.dart';

typedef ImageGenerationResult = ({String aiPrompt, String postfix, String url});

const _assistantId = 'asst_0Qd2vXvNA5gGggaM1TV9qPzS';

class AiService {
  AiService(String apiKey, ThreadStore store)
      : _assistantApi = AssistantApi(
          apiKey: apiKey,
          assistantId: _assistantId,
          threadStore: store,
        );

  final AssistantApi _assistantApi;

  Future<String?> nextPhrase(String userId, String word) async {
    final prompt = jsonEncode({
      "exercise_request": {
        "source_language": "nl",
        "target_language": "en",
        "level": "A1",
        "word": word,
      },
    });
    print('nextPhrase prompt: $prompt');
    final response = await _assistantApi.addMessageToThread(userId, prompt);

    return _parseResponse(
      response,
      (data) => data['exercise'],
    );
  }

  Future<Evaluation?> checkTranslation(String userId, MapEntry<String, String> exercise, String translation) async {
    final evaluationRequest = {
      "evaluation_request": {
        "source_language": "nl",
        "target_language": "en",
        "exercise": Map.fromEntries([exercise]),
        "translation": translation,
      }
    };
    final response = await _assistantApi.addMessageToThread(userId, jsonEncode(evaluationRequest));

    return _parseResponse(
      response,
      (data) => Evaluation.fromJson(data),
    );
  }

  Future<Map<String, String>> getExercises(List<String> words) async {
    final prompt = jsonEncode({
      "exercise_request": {
        "source_language": "nl",
        "target_language": "en",
        "level": "A1",
        "words": words,
      },
    });

    final response = await _assistantApi.addMessageToThread(_assistantId, prompt);
    if (response == null) {
      throw Exception('Empty AI prompt');
    }

    final exercises = _parseResponse(
      response,
      (data) => data['exercises'],
    );
    //print type of exercises
    print('exercises type: ${exercises.runtimeType}');

    final map = Map<String, String>.from(exercises);

    return map;
  }
}

class InappropriatePrompt implements Exception {
  @override
  String toString() => 'InappropriatePrompt';
}

T _parseResponse<T>(String? response, T Function(Map<String, dynamic>) parser) {
  final json = response == null ? null : jsonDecode(response);

  if (json == null) {
    throw Exception('Empty AI prompt');
  } else if (json['error'] != null) {
    throw Exception(json['error']);
  }

  // final value = json[jsonKey];
  // if (value == null) {
  //   throw Exception('Empty AI prompt');
  // }

  return parser(json);
}
