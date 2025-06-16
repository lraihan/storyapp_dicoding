import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../data/shared/app_config.dart';
import '../controllers/add_story_controller.dart';
import '../../../routes/app_pages.dart';

class AddStoryView extends GetView<AddStoryController> {
  const AddStoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(Routes.HOME);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add New Story'.tr),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(Routes.HOME),
          ),
        ),
        body: Obx(
          () => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => controller.showImageSourceDialog(context),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            minHeight: 150,
                            maxHeight: 300,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: controller.selectedImage.value != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    controller.selectedImage.value!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 64,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'tapToSelectImage'.tr,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    if (controller.selectedImage.value != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'File size: ${controller.selectedImage.value!.lengthSync() > 0 ? '${(controller.selectedImage.value!.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB' : 'Unknown'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (controller.selectedImage.value!.lengthSync() > 1000000) ...[
                              Icon(
                                Icons.warning,
                                size: 16,
                                color: Colors.orange[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Large',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ] else ...[
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      'description'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter Description'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: controller.validateDescription,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'location'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (AppConfig.isPaidVersion) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'PRO',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'PRO ONLY',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (controller.selectedLocation.value != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[50],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    controller.locationAddress.value.isEmpty
                                        ? 'loadingAddress'.tr
                                        : controller.locationAddress.value,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: controller.removeLocation,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'lat: ${controller.selectedLocation.value!.latitude.toStringAsFixed(6)}, lng: ${controller.selectedLocation.value!.longitude.toStringAsFixed(6)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      GestureDetector(
                        onTap: () => controller.pickLocation(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppConfig.isPaidVersion ? Colors.grey[300]! : Colors.grey[400]!,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: AppConfig.isPaidVersion ? Colors.grey[50] : Colors.grey[100],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.add_location,
                                size: 48,
                                color: AppConfig.isPaidVersion ? Colors.grey[600] : Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppConfig.isPaidVersion
                                    ? 'tapToSelectLocation'.tr
                                    : 'locationNotAvailableInFreeVersion'.tr,
                                style: TextStyle(
                                  color: AppConfig.isPaidVersion ? Colors.grey[600] : Colors.grey[400],
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : () => controller.uploadStory(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Upload Story'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withAlpha((0.3 * 255).toInt()),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
