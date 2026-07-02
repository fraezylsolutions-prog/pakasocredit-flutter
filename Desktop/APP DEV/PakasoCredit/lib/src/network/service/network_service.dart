import 'dart:async';
import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/api_response.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;

class NetworkService extends GetxService {
  final Dio _dio = Dio();
  final CookieJar cookieJar = CookieJar();
  final String baseUrl = ApiPath.baseUrl;
  late TokenService _tokenService;

  @override
  void onInit() {
    super.onInit();
    _tokenService = Get.find<TokenService>();
    _configureHttpClient();
  }

  void _configureHttpClient() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.contentType = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(CookieManager(cookieJar));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? accessToken = _tokenService.accessToken.value;
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            _log("Unauthorized access - 401");
          }
          return handler.next(error);
        },
      ),
    );
  }

  // --- Core API Methods ---

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiPath.loginEndpoint,
        data: {'email': email, 'username': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        String? accessToken = response.data['token'] ?? response.data['access_token'] ?? response.data['data']?['token'];
        if (accessToken != null) {
          await _tokenService.saveAccessToken(accessToken);
          _setupInterceptors(); 
          return ApiResponse.completed(response.data);
        }
      }
      return ApiResponse.error(response.data?['message'] ?? 'Login failed');
    } on DioException catch (e) {
      return _handleDioException(e, "Login");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> registerStepOne({required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.post(ApiPath.registerStepOneEndpoint, data: jsonEncode(data));
      return _handleResponse(response, "Register Step One");
    } on DioException catch (e) {
      return _handleDioException(e, "Register Step One");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> registerStepTwo({required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.post(ApiPath.registerStepTwoEndpoint, data: jsonEncode(data));
      if (response.statusCode == 200) {
        String? accessToken = response.data['token'] ?? response.data['access_token'];
        if (accessToken != null) {
          await _tokenService.saveAccessToken(accessToken);
          _setupInterceptors();
        }
        return ApiResponse.completed(response.data);
      }
      return ApiResponse.error(response.data?['message'] ?? 'Registration failed');
    } on DioException catch (e) {
      return _handleDioException(e, "Register Step Two");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> get({required String endpoint}) async {
    try {
      final response = await _dio.get(endpoint);
      return _handleResponse(response, "GET");
    } on DioException catch (e) {
      return _handleDioException(e, "GET");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> post({required String endpoint, Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data != null ? jsonEncode(data) : null);
      return _handleResponse(response, "POST");
    } on DioException catch (e) {
      return _handleDioException(e, "POST");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> put({required String endpoint, Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(endpoint, data: data != null ? jsonEncode(data) : null);
      return _handleResponse(response, "PUT");
    } on DioException catch (e) {
      return _handleDioException(e, "PUT");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> delete({required String endpoint, Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data != null ? jsonEncode(data) : null);
      return _handleResponse(response, "DELETE");
    } on DioException catch (e) {
      return _handleDioException(e, "DELETE");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> globalGet({required String endpoint}) async {
    try {
      final response = await _dio.get(endpoint);
      return _handleResponse(response, "Global GET");
    } on DioException catch (e) {
      return _handleDioException(e, "Global GET");
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> globalPost({required String endpoint, Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post(endpoint, data: data != null ? jsonEncode(data) : null);
      return _handleResponse(response, "Global POST");
    } on DioException catch (e) {
      return _handleDioException(e, "Global POST");
    }
  }

  // --- Helper Methods ---

  ApiResponse<Map<String, dynamic>> _handleResponse(Response response, String type) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = response.data as Map<String, dynamic>;
      return ApiResponse.completed(jsonData);
    }
    return ApiResponse.error('Error occurred: ${response.statusCode}');
  }

  ApiResponse<Map<String, dynamic>> _handleDioException(DioException e, String type) {
    String message = "Connection error. Please try again.";
    if (e.response != null) {
      message = e.response?.data?['message']?.toString() ?? "Server error (${e.response?.statusCode})";
      if (e.response?.statusCode == 401) {
        _showUnauthorizedDialog();
      }
    } else if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      message = "Request timed out.";
    }

    _showToast(message);
    return ApiResponse.error(message);
  }

  void _showUnauthorizedDialog() {
    final ThemeController themeController = Get.find<ThemeController>();
    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: themeController.isDarkMode.value ? AppColors.darkSecondary : AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Unauthorized", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                const Text("Your session has expired. Please login again.", textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => Get.offAllNamed(BaseRoute.signIn), child: const Text("Ok"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _log(String msg) { if (kDebugMode) print('🌐 NetworkService: $msg'); }
  void _showToast(String msg) { Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red, gravity: ToastGravity.BOTTOM); }
}
