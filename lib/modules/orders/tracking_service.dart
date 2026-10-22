import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../auth/auth_session.dart';
import 'models/tracking_line_model.dart';

class TrackingService {
  final Dio _dio;

  TrackingService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<TrackingLineModel>> getTracking(int orderId) async {
    final userId = AuthSession.userId;
    final password = AuthSession.password;

    if (userId == null || password == null) {
      throw Exception('User is not authenticated');
    }

    final response = await _dio.post(
      ApiConstants.jsonRpc,
      data: {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'service': 'object',
          'method': 'execute_kw',
          'args': [
            ApiConstants.database,
            userId,
            password,
            'order.tracking.line',
            'search_read',
            [
              [
                ['order_id', '=', orderId],
              ],
            ],
            {
              'fields': ['remarks', 'lmd_status_id', 'date_update'],
            },
          ],
        },
        'id': 2,
      },
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid server response');
    }

    if (data['error'] != null) {
      throw Exception('Tracking request failed: ${data['error']}');
    }

    final result = data['result'];

    if (result is! List) {
      throw Exception('Invalid tracking response');
    }

    return result
        .whereType<Map<String, dynamic>>()
        .map(TrackingLineModel.fromJson)
        .toList();
  }
}
