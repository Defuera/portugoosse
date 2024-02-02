import 'dart:convert';

import 'package:ai_assistant/src/assistant_api.dart';

typedef ImageGenerationResult = ({String aiPrompt, String postfix, String url});

const _assistantId = 'asst_0Qd2vXvNA5gGggaM1TV9qPzS';

class AiService {
  AiService(String apiKey) : _assistantApi = AssistantApi(apiKey: apiKey, assistantId: _assistantId);

  final AssistantApi _assistantApi;

  Future<String?> nextPhrase(String word) async {
    final prompt = jsonEncode({
      "exercise_request": {
        "source_language": "nl",
        "target_language": "en",
        "level": "A1",
        "word": word,
      },
    });
    print('nextPhrase prompt: $prompt');
    final response = await _assistantApi.addMessageToThread(prompt);

    return _parseResponse(response, 'exercise');
  }

  Future<String?> checkTranslation(String translation) async {
    final evaluationRequest = {
      "evaluation_request": {
        "source_language": "nl",
        "target_language": "en",
        "translation": translation,
      }
    };
    final response = await _assistantApi.addMessageToThread(jsonEncode(evaluationRequest));

    return _parseResponse(response, 'evaluation');
  }
}

class InappropriatePrompt implements Exception {
  @override
  String toString() => 'InappropriatePrompt';
}

_parseResponse(String? response, String jsonKey) {
  final json = response == null ? null : jsonDecode(response);

  if (json == null) {
    throw Exception('Empty AI prompt');
  } else if (json['error'] != null) {
    throw Exception(json['error']);
  }

  final exercise = json[jsonKey];
  if (exercise == null) {
    throw Exception('Empty AI prompt');
  }

  return exercise;
}
