import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../data/service/api_service.dart';
import '../../../data/models/story_model.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final stories = <Story>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadStories();
  }

  Future<void> loadStories() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await _apiService.getStories();

      if (!response.error) {
        stories.value = response.listStory;
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load stories';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStories() async {
    await loadStories();
  }

  void goToStoryDetail(BuildContext context, String storyId) {
    context.go('${Routes.STORY_DETAIL}?id=$storyId');
  }

  void goToAddStory(BuildContext context) {
    context.go(Routes.ADD_STORY);
  }

  void logout(BuildContext context) {
    _apiService.logout();
    context.go(Routes.LOGIN);
  }
}
