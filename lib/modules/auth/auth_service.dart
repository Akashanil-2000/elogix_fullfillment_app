import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<EmailValidationResult> validateEmail({required String email}) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}/app/api/user_valid',
      data: {'email': email.trim()},
    );

    final data = response.data;

    if (data is! Map) {
      throw Exception('Invalid server response');
    }

    final result = data['result'];

    if (result is! Map) {
      throw Exception('Invalid email validation response');
    }

    return EmailValidationResult(
      success: result['success'] == true,
      message: result['message']?.toString() ?? 'Unable to validate email',
      name: result['data'] is Map ? result['data']['name']?.toString() : null,
    );
  }

  Future<int?> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.jsonRpc,
      data: {
        'jsonrpc': '2.0',
        'method': 'login',
        'params': {
          'service': 'common',
          'method': 'login',
          'args': [ApiConstants.database, username, password],
        },
        'id': 1,
      },
    );

    final data = response.data;
    final result = data['result'];

    if (result is int) {
      return result;
    }

    if (result == false) {
      return null;
    }

    return null;
  }
}

class EmailValidationResult {
  final bool success;
  final String message;
  final String? name;

  const EmailValidationResult({
    required this.success,
    required this.message,
    this.name,
  });
}
