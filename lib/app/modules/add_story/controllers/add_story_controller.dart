// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/service/api_service.dart';
import '../../../routes/app_pages.dart';

class AddStoryController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final ImagePicker _picker = ImagePicker();

  final descriptionController = TextEditingController();
  final selectedImage = Rxn<File>();
  final isLoading = false.obs;

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> pickImageFromCamera() async {
    final permission = await Permission.camera.request();
    if (permission.isGranted) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
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
        selectedImage.value = File(image.path);
      }
    } else {
      final storagePermission = await Permission.storage.request();
      if (storagePermission.isGranted) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (image != null) {
          selectedImage.value = File(image.path);
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
    context.go(Routes.HOME);
  }

  Future<void> uploadStory(BuildContext context) async {
    if (!validateForm(context)) return;

    isLoading.value = true;

    try {
      final response = await _apiService.addStory(
        description: descriptionController.text.trim(),
        photo: selectedImage.value!,
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

        goBackToHome(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('uploadFailed'.tr),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
