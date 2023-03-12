import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:socale/models/user/user/user.dart';

part 'current_user.freezed.dart';

part 'current_user.g.dart';

@freezed
class CurrentUser with _$CurrentUser {
  const CurrentUser._();

  const factory CurrentUser({
    @Default(User(email: '')) User user,
    @JsonWebTokenSerializer() JsonWebToken? idToken,
    @JsonWebTokenSerializer() JsonWebToken? accessToken,
    String? refreshToken,
  }) = _CurrentUser;

  factory CurrentUser.fromJson(Map<String, dynamic> json) => _$CurrentUserFromJson(json);
}

class JsonWebTokenConverter extends JsonConverter<JsonWebToken, String> {
  @override
  JsonWebToken fromJson(String json) {
    return JsonWebToken.parse(json);
  }

  @override
  String toJson(JsonWebToken object) {
    return object.toJson();
  }
}
