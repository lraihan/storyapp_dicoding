import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/api_service.dart';
import '../../../data/models/auth_model.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final loginMessage = ''.obs;
  final registerMessage = ''.obs;
  final isLoginSuccess = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'pleaseEnterEmail'.tr;
    }
    if (!GetUtils.isEmail(value)) {
      return 'invalidEmail'.tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'pleaseEnterPassword'.tr;
    }
    if (value.length < 8) {
      return 'passwordTooShort'.tr;
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'pleaseEnterName'.tr;
    }
    return null;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      loginMessage.value = 'Please enter email and password';
      return;
    }

    isLoading.value = true;
    loginMessage.value = '';

    try {
      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final response = await _apiService.login(request);

      if (!response.error) {
        loginMessage.value = 'Login successful!';

        await Future.delayed(const Duration(milliseconds: 300));

        if (_apiService.isLoggedIn()) {
          isLoginSuccess.value = true;
        } else {
          loginMessage.value = 'Login failed to save session. Please try again.';
        }
      } else {
        loginMessage.value = response.message;
      }
    } catch (e) {
      loginMessage.value = 'Login failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      registerMessage.value = 'Please fill in all fields';
      return;
    }

    isLoading.value = true;
    registerMessage.value = '';

    try {
      final request = RegisterRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final response = await _apiService.register(request);

      if (!response.error) {
        registerMessage.value = 'Registration successful! Please login.';

        nameController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        registerMessage.value = response.message;
      }
    } catch (e) {
      registerMessage.value = 'Registration failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
