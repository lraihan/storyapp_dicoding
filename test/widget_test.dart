import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:storyapp_dicoding/app/data/models/story_model.dart';

void main() {
  setUp(() {

    Get.reset();
  });

  test('Story model serialization works correctly', () {

    final storyJson = {
      'id': 'test-id',
      'name': 'Test User',
      'description': 'Test story description',
      'photoUrl': 'https://example.com/photo.jpg',
      'createdAt': '2024-01-01T00:00:00.000Z',
      'lat': 1.0,
      'lon': 2.0,
    };

    final story = Story.fromJson(storyJson);
    expect(story.id, equals('test-id'));
    expect(story.name, equals('Test User'));
    expect(story.description, equals('Test story description'));
    expect(story.photoUrl, equals('https://example.com/photo.jpg'));
    expect(story.lat, equals(1.0));
    expect(story.lon, equals(2.0));

    final backToJson = story.toJson();
    expect(backToJson['id'], equals('test-id'));
    expect(backToJson['name'], equals('Test User'));
    expect(backToJson['description'], equals('Test story description'));
    expect(backToJson['photoUrl'], equals('https://example.com/photo.jpg'));
    expect(backToJson['lat'], equals(1.0));
    expect(backToJson['lon'], equals(2.0));
  });

  test('StoryResponse parsing works correctly', () {
    final responseJson = {
      'error': false,
      'message': 'Stories fetched successfully',
      'listStory': [
        {
          'id': 'story-1',
          'name': 'User 1',
          'description': 'Description 1',
          'photoUrl': 'https://example.com/photo1.jpg',
          'createdAt': '2024-01-01T00:00:00.000Z',
        },
        {
          'id': 'story-2',
          'name': 'User 2',
          'description': 'Description 2',
          'photoUrl': 'https://example.com/photo2.jpg',
          'createdAt': '2024-01-02T00:00:00.000Z',
        }
      ]
    };

    final response = StoryResponse.fromJson(responseJson);
    expect(response.error, equals(false));
    expect(response.message, equals('Stories fetched successfully'));
    expect(response.listStory.length, equals(2));
    expect(response.listStory[0].id, equals('story-1'));
    expect(response.listStory[1].id, equals('story-2'));
  });

  tearDown(() {

    Get.reset();
  });
}
