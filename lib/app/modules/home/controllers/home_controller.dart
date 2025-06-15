import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../data/service/api_service.dart';
import '../../../data/models/story.dart';
import '../../../routes/app_pages.dart';
class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  static const int _pageSize = 10;
  late final PagingController<int, Story> pagingController;
  final isRefreshing = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  @override
  void onInit() {
    super.onInit();
    pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }
  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await _apiService.getStories(
        page: pageKey,
        size: _pageSize,
      );
      if (!response.error) {
        final newItems = response.listStory;
        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
        hasError.value = false;
        errorMessage.value = '';
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
        pagingController.error = response.message;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load stories: $e';
      pagingController.error = e;
    }
  }
  Future<void> refreshStories() async {
    isRefreshing.value = true;
    pagingController.refresh();
    isRefreshing.value = false;
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
