import 'dart:convert';

import 'package:chatterbox/chatterbox.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:portugoose/config.dart';
import 'package:portugoose/flows/start.dart';
import 'package:portugoose/store_proxy.dart';
import 'package:shelf/shelf.dart';

@CloudFunction()
Future<Response> function(Request request) async {
  try {
    final flows = <Flow>[StartFlow()];

    Chatterbox(Config.botToken, flows, StoreProxy()).invokeFromWebhook(await parseRequestBody(request));
    return Response.ok(
      null,
      headers: {'Content-Type': 'application/json'},
    );
  } catch (error) {
    return Response.badRequest();
  }
}

Future<Map<String, dynamic>> parseRequestBody(Request request) async {
  final bodyBytes = await request.read().toList();
  final bodyString = utf8.decode(bodyBytes.expand((i) => i).toList());
  final jsonObject = jsonDecode(bodyString) as Map<String, dynamic>;

  return jsonObject;
}
