// import 'package:flutter/foundation.dart';
// // import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';

// import '../../routes/app_pages.dart';

// /// Base Provider - extends GetConnect with auth configuration
// class BaseProvider extends GetConnect {
//   static const String _tokenKey = 'access_token';
//   static bool _isRedirectingToLogin = false;

//   // final _storage = const FlutterSecureStorage(
//   //   aOptions: AndroidOptions(encryptedSharedPreferences: true),
//   //   iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
//   // );

//   BaseProvider() {
//     _configureHttpClient();
//   }

//   void _configureHttpClient() {
//     final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
//     httpClient.baseUrl = '$baseUrl/api/v1';
//     httpClient.timeout = const Duration(seconds: 30);

//     // Default headers
//     httpClient.addRequestModifier<dynamic>((request) async {
//       request.headers['Accept'] = 'application/json';
//       request.headers['Content-Type'] = 'application/json';

//       // Add auth token if available
//       final token = await _storage.read(key: _tokenKey);
//       if (token != null && token.isNotEmpty) {
//         request.headers['Authorization'] = 'Bearer $token';
//       }

//       return request;
//     });

//     // Response modifier for error handling
//     httpClient.addResponseModifier((request, response) {
//       if (response.statusCode == 401) {
//         debugPrint('BaseProvider: 401 on ${request.url}');
//         _handleUnauthorized();
//       }
//       return response;
//     });
//   }

//   // /// Handle 401 - clear token and redirect to login (once)
//   // Future<void> _handleUnauthorized() async {
//   //   if (_isRedirectingToLogin) return;
//   //   _isRedirectingToLogin = true;

//   //   await _storage.delete(key: _tokenKey);

//   //   // Only redirect if not already on auth page
//   //   if (Get.currentRoute != Routes.AUTH) {
//   //     Get.offAllNamed(Routes.AUTH);
//   //   }

//   //   // Reset flag after a delay to prevent rapid re-triggers
//   //   Future.delayed(const Duration(seconds: 2), () {
//   //     _isRedirectingToLogin = false;
//   //   });
//   // }

//   @override
//   void onInit() {
//     super.onInit();
//     _configureHttpClient();
//   }
// }
