import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String?;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      if (refreshToken != null) {
        await prefs.setString('refreshToken', refreshToken);
      }
      await prefs.setString('email', email);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('email');
  }
}
