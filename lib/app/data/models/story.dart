import 'package:json_annotation/json_annotation.dart';
part 'story.g.dart';
@JsonSerializable()
class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;
  const Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });
  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);
  bool get hasLocation => lat != null && lon != null;
}
@JsonSerializable()
class StoryResponse {
  final bool error;
  final String message;
  final List<Story> listStory;
  const StoryResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });
  factory StoryResponse.fromJson(Map<String, dynamic> json) => _$StoryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StoryResponseToJson(this);
}
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool error;
  final String message;
  final T? data;
  const ApiResponse({
    required this.error,
    required this.message,
    this.data,
  });
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?)? fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT!);
  Map<String, dynamic> toJson(Object? Function(T)? toJsonT) => _$ApiResponseToJson(this, toJsonT!);
}
