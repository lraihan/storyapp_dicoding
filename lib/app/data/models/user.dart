import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';
@JsonSerializable()
class User {
  final String userId;
  final String name;
  final String token;
  const User({
    required this.userId,
    required this.name,
    required this.token,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
@JsonSerializable()
class LoginResponse {
  final bool error;
  final String message;
  final User? loginResult;
  const LoginResponse({
    required this.error,
    required this.message,
    this.loginResult,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
@JsonSerializable()
class RegisterResponse {
  final bool error;
  final String message;
  const RegisterResponse({
    required this.error,
    required this.message,
  });
  factory RegisterResponse.fromJson(Map<String, dynamic> json) => _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  const LoginRequest({
    required this.email,
    required this.password,
  });
  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
@JsonSerializable()
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
  });
  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
