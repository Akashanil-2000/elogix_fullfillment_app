import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';

class AuthService {
  final Dio _dio = Dio();

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
