A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.


### New Cloud Functions Telegram bot project 

#### Skeleton
1. Create a project
2. Add dependencies
```yaml
dependencies:
    chatterbox: ^1.0.0
    functions_framework: ^0.4.0
    shelf: ^1.0.0
dev_dependencies:
  build_runner: ^2.0.0
  functions_framework_builder: ^0.4.0
```
3. create lib/functions.dart
```dart
@CloudFunction()
Future<Response> function(Map<String, dynamic> updateJson) async {
  try {
    final flows = <Flow>[
      //todo
    ];

    Chatterbox(Config.botToken, flows, StoreProxy()).invokeFromWebhook(updateJson);
    return Response.ok(
      null,
      headers: {'Content-Type': 'application/json'},
    );
  } catch (error) {
    return Response.badRequest();
  }
}
```
4. Add config.dart
```dart
import 'dart:io';

class Config {
  Config._();

  static String get botName => env('BOT_NAME');

  static String get botToken => env('BOT_TOKEN');
}

T env<T>(String key) {
  final value = Platform.environment[key];
  if (value == null) {
    throw 'Missing $key environment variable';
  } else {
    print('$key: ${value.substring(0, 5)}');
    return value as T;
  }
}
```
5. Add Makefile
```makefile
.PHONY: clean

FUNCTION_TARGET = function
PORT = 8080

# bin/server.dart is the generated target for lib/functions.dart
bin/server.dart:
	dart run build_runner build --delete-conflicting-outputs

build: bin/server.dart

test: clean build
	dart test

clean:
	dart run build_runner clean
	rm -rf bin/server.dart

run: build
	dart run bin/server.dart --port=$(PORT) --target=$(FUNCTION_TARGET)
	
gen_all:
	dart run build_runner build --delete-conflicting-outputs

```

#### Create Telegram Bot
1. Go to Telegram https://t.me/BotFather and create a new bot
2. Store env variables 
```shell
BOT_NAME=portugoosse_bot;BOT_TOKEN=6574774245:AAG7ErwTd2Gol5Jrtu-_U9wuWVscWXaM500
```

#### Building
1. Run `make gen_all`
2. From another terminal run a test command
```shell
$ curl -X POST -H "content-type: application/json" -d '{ "name": "World" }' -i localhost:8080
```
You should see the response
```shell
HTTP/1.1 200 OK
x-powered-by: Dart with package:shelf
date: Thu, 26 Oct 2023 07:18:50 GMT
content-length: 0
x-frame-options: SAMEORIGIN
content-type: application/json
x-xss-protection: 1; mode=block
x-content-type-options: nosniff
```