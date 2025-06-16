import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/service/api_service.dart';
import '../../../data/service/location_service.dart';
import '../../../data/service/image_compression_service.dart';
import '../../../data/shared/app_config.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/location_coordinate.dart';
import '../../home/controllers/home_controller.dart';

class AddStoryController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final LocationService _locationService = Get.find<LocationService>();
  final ImagePicker _picker = ImagePicker();
  final descriptionController = TextEditingController();
  final selectedImage = Rxn<File>();
  final selectedLocation = Rxn<LocationCoordinate>();
  final locationAddress = ''.obs;
  final isLoading = false.obs;
  final isLocationAvailable = false.obs;
  @override
  void onInit() {
    super.onInit();
    _checkLocationAvailability();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> _checkLocationAvailability() async {
    isLocationAvailable.value = await _locationService.isLocationAvailable();
  }

  Future<void> pickImageFromCamera() async {
    final permission = await Permission.camera.request();
    if (permission.isGranted) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        await _processSelectedImage(File(image.path));
      }
    } else {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to take photos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    final permission = await Permission.photos.request();
    if (permission.isGranted) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        await _processSelectedImage(File(image.path));
      }
    } else {
      final storagePermission = await Permission.storage.request();
      if (storagePermission.isGranted) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
          await _processSelectedImage(File(image.path));
        }
      } else {
        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(
              content: Text('Photo access permission is required to select images'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _processSelectedImage(File imageFile) async {
    try {
      if (Get.context != null) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (!ImageCompressionService.isFileSizeValid(imageFile)) {
        final originalSize = ImageCompressionService.getFileSizeString(imageFile);
        final compressedFile = await ImageCompressionService.compressImageToSize(imageFile);
        if (compressedFile != null) {
          final compressedSize = ImageCompressionService.getFileSizeString(compressedFile);
          selectedImage.value = compressedFile;
          if (Get.context != null) {
            Get.context!.pop();
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                content: Text('Image compressed from $originalSize to $compressedSize'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (Get.context != null) {
            Get.context!.pop();
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(
                content: Text('Failed to compress image. Please try a smaller image or different format.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        selectedImage.value = imageFile;
        if (Get.context != null) {
          Get.context!.pop();
        }
      }
    } catch (e) {
      if (Get.context != null) {
        Get.context!.pop();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Error processing image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                context.pop();
                pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                context.pop();
                pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'pleaseEnterDescription'.tr;
    }
    return null;
  }

  bool validateForm(BuildContext context) {
    if (selectedImage.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pleaseSelectImage'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pleaseEnterDescription'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  void goBackToHome(BuildContext context) {
    try {
      final homeController = Get.find<HomeController>();
      homeController.refreshStories();
    } catch (e) {
      debugPrint('Error finding HomeController: $e');
    }
    context.go(Routes.HOME);
  }

  Future<void> uploadStory(BuildContext context) async {
    if (!validateForm(context)) return;
    if (selectedImage.value != null && !ImageCompressionService.isFileSizeValid(selectedImage.value!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Image size (${ImageCompressionService.getFileSizeString(selectedImage.value!)}) exceeds 1MB limit. Please select a smaller image.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    isLoading.value = true;
    try {
      final response = await _apiService.addStory(
        description: descriptionController.text.trim(),
        photo: selectedImage.value!,
        lat: selectedLocation.value?.latitude,
        lon: selectedLocation.value?.longitude,
      );
      if (!response.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('uploadSuccess'.tr),
            backgroundColor: Colors.green,
          ),
        );
        descriptionController.clear();
        selectedImage.value = null;
        selectedLocation.value = null;
        locationAddress.value = '';
        goBackToHome(context);
      } else {
        String errorMessage = response.message;
        if (errorMessage.toLowerCase().contains('payload') && errorMessage.toLowerCase().contains('size')) {
          errorMessage = 'Image is too large. Please select a smaller image.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      String errorMessage = 'uploadFailed'.tr;
      if (e.toString().toLowerCase().contains('payload') || e.toString().toLowerCase().contains('size')) {
        errorMessage = 'Image is too large. Please select a smaller image.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickLocation(BuildContext context) async {
    if (!AppConfig.isPaidVersion) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('locationFeatureNotAvailable'.tr),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final params = <String, String>{};
    if (selectedLocation.value != null) {
      params['lat'] = selectedLocation.value!.latitude.toString();
      params['lng'] = selectedLocation.value!.longitude.toString();
    }

    final result = await context.push<LocationCoordinate>(
        Uri(path: '/location-picker', queryParameters: params.isEmpty ? null : params).toString());

    if (result != null) {
      selectedLocation.value = result;
      _loadLocationAddress();
    }
  }

  Future<void> _loadLocationAddress() async {
    if (selectedLocation.value != null) {
      final address = await _locationService.getAddressFromCoordinates(
        selectedLocation.value!.latitude,
        selectedLocation.value!.longitude,
      );
      locationAddress.value = address ?? 'unknownLocation'.tr;
    }
  }

  void removeLocation() {
    selectedLocation.value = null;
    locationAddress.value = '';
  }
}
