import 'package:openai_api/openai_api.dart';

String? threadId;

class AssistantApi {
  AssistantApi({required this.apiKey, required this.assistantId})
      : _client = OpenaiClient(config: OpenaiConfig(apiKey: apiKey));

  final OpenaiClient _client;

  final String apiKey;
  final String assistantId;

  Future<ImageResponse> generateImage(String prompt, bool dalle3) async {
    final result = await _client.createImage(ImageRequest(
      prompt: prompt,
      model: dalle3 ? Models.dallE3 : Models.dallE2,
      n: 1,
      style: 'vivid',
      size: dalle3 ? '1024x1024' : '256x256',
    ));
    return result;
  }

  /// Add message to existing thread or create a new thread if there's no thread yet
  Future<String?> addMessageToThread(String message) async {
    final threadId = await _getThreadId();

    await _client.addThreadMessage(ChatMessage(role: ChatMessageRole.user, content: message), threadId);

    final run = await _client.createThreadRun(threadId: threadId, assistantId: assistantId);

    await _awaitRunStatusCompleted(threadId, run.id);

    final response = await _client.getThreadMessages(threadId);
    print('Assistant response ${response.toString()}');

    //todo there could be more then one message added to a thread as a response, return all of them
    final lastMessage = response.data.firstOrNull?.content.lastOrNull?.text.value;
    if (lastMessage == null) {
      return null;
    }
    return lastMessage;
  }

  Future<String> _getThreadId() async {
    if (threadId == null) {
      final thread = await _client.createThread();
      threadId = thread.id;
    }

    print('threadId: $threadId');
    return threadId!;
  }

  Future<void> _awaitRunStatusCompleted(String threadId, String runId) async {
    final runStatus = await _client.getThreadRunStatus(threadId: threadId, runId: runId);
    if (runStatus.status != 'completed') {
      await Future.delayed(Duration(seconds: 2));
      await _awaitRunStatusCompleted(threadId, runId);
    }
  }
}
