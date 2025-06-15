import 'package:get/get.dart';
import '../controllers/story_detail_controller.dart';
class StoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoryDetailController>(() => StoryDetailController());
  }
}
