import 'package:database/src/models/session_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_progress_dto.freezed.dart';

part 'user_progress_dto.g.dart';

@Freezed(toJson: true, fromJson: true)
class UserProgressDto with _$UserProgressDto {
  const factory UserProgressDto({
    int? totalSessions,
    int? totalWordsReviewed,
    int? lastSessionAt,
    SessionDto? session,
    SessionDto? prevSession,
  }) = _UserProgressDto;

  factory UserProgressDto.fromJson(Map<String, dynamic> json) => _$UserProgressDtoFromJson(json);
}

enum UserState {
  runningSession
}

