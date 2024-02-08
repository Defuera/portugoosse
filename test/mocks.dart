import 'package:ai_assistant/ai_assistant.dart';
import 'package:database/database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:portugoose/services/deck_manager.dart';
import 'package:portugoose/services/internal/srs_manager.dart';

class MockAiService extends Mock implements AiService {}

class MockSrsManager extends Mock implements SrsManager {}

class MockUserProgressDao extends Mock implements UserProgressDao {}

class MockDeckManager extends Mock implements DeckManager {}
