import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../data/service/api_service.dart';
import '../../../data/models/story_model.dart';
import '../../../routes/app_pages.dart';

class StoryDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final story = Rxn<Story>();
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  String storyId = '';

  void setStoryId(String id) {
    storyId = id;
    loadStoryDetail();
  }

  Future<void> loadStoryDetail() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await _apiService.getStoryDetail(storyId);

      if (!response.error && response.data != null) {
        story.value = response.data;
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load story detail';
    } finally {
      isLoading.value = false;
    }
  }

  void goBackToHome(BuildContext context) {
    context.go(Routes.HOME);
  }
}
