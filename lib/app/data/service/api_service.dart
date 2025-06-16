import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user.dart';
import '../models/story.dart';
import '../../config/environment_config.dart';

class ApiService {
  late final Dio _dio;
  final GetStorage _storage = GetStorage();

  ApiService() {
    _dio = Dio();
    _dio.options.baseUrl = EnvironmentConfig.apiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.read('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _storage.remove('token');
            _storage.remove('user');
          }
          handler.next(error);
        },
      ),
    );
  }
  Future<ApiResponse<User>> login(LoginRequest request) async {
    try {
      final response = await _dio.post('/login', data: request.toJson());
      final loginData = response.data['loginResult'];
      final apiResponse = ApiResponse<User>(
        error: response.data['error'] ?? false,
        message: response.data['message'] ?? '',
        data: loginData != null ? User.fromJson(loginData) : null,
      );
      if (!apiResponse.error && apiResponse.data != null) {
        _storage.write('token', apiResponse.data!.token);
        _storage.write('user', apiResponse.data!.toJson());
      }
      return apiResponse;
    } on DioException catch (e) {
      return ApiResponse<User>(
        error: true,
        message: e.response?.data?['message'] ?? 'Login failed',
      );
    }
  }

  Future<ApiResponse<String>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post('/register', data: request.toJson());
      return ApiResponse<String>(
        error: response.data['error'] ?? false,
        message: response.data['message'] ?? '',
        data: response.data['message'],
      );
    } on DioException catch (e) {
      return ApiResponse<String>(
        error: true,
        message: e.response?.data?['message'] ?? 'Registration failed',
      );
    }
  }

  Future<StoryResponse> getStories({int page = 1, int size = 10, int location = 0}) async {
    try {
      final response = await _dio.get('/stories', queryParameters: {
        'page': page,
        'size': size,
        'location': location,
      });
      return StoryResponse.fromJson(response.data);
    } on DioException catch (e) {
      return StoryResponse(
        error: true,
        message: e.response?.data?['message'] ?? 'Failed to fetch stories',
        listStory: [],
      );
    }
  }

  Future<ApiResponse<Story>> getStoryDetail(String id) async {
    try {
      final response = await _dio.get('/stories/$id');
      final responseData = response.data;
      final story = responseData['story'];
      return ApiResponse<Story>(
        error: responseData['error'] ?? false,
        message: responseData['message'] ?? '',
        data: story != null ? Story.fromJson(story) : null,
      );
    } on DioException catch (e) {
      return ApiResponse<Story>(
        error: true,
        message: e.response?.data?['message'] ?? 'Failed to fetch story detail',
      );
    }
  }

  Future<ApiResponse<String>> addStory({
    required String description,
    required File photo,
    double? lat,
    double? lon,
  }) async {
    try {
      final formData = FormData.fromMap({
        'description': description,
        'photo': await MultipartFile.fromFile(photo.path),
        if (lat != null) 'lat': lat.toString(),
        if (lon != null) 'lon': lon.toString(),
      });
      final response = await _dio.post('/stories', data: formData);
      return ApiResponse<String>(
        error: response.data['error'] ?? false,
        message: response.data['message'] ?? '',
        data: response.data['message'],
      );
    } on DioException catch (e) {
      String errorMessage = 'Failed to add story';
      if (e.response != null) {
        if (e.response!.statusCode == 413) {
          errorMessage = 'Image is too large. Please select a smaller image.';
        } else if (e.response?.data != null) {
          final responseData = e.response!.data;
          if (responseData is Map && responseData.containsKey('message')) {
            errorMessage = responseData['message'];
            if (errorMessage.toLowerCase().contains('payload') &&
                errorMessage.toLowerCase().contains('content length')) {
              errorMessage = 'Image size exceeds 1MB limit. Please select a smaller image.';
            }
          }
        }
      } else if (e.message != null && e.message!.toLowerCase().contains('payload')) {
        errorMessage = 'Image size exceeds 1MB limit. Please select a smaller image.';
      }
      return ApiResponse<String>(
        error: true,
        message: errorMessage,
      );
    }
  }

  Future<void> logout() async {
    _storage.remove('token');
    _storage.remove('user');
  }

  String? getToken() {
    return _storage.read('token');
  }

  User? getCurrentUser() {
    final userData = _storage.read('user');
    if (userData != null) {
      return User.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  bool isLoggedIn() {
    return getToken() != null;
  }
}
