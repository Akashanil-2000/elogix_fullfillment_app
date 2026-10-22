import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../auth/auth_session.dart';
import 'models/service_order_model.dart';

class OrderService {
  final Dio _dio;

  OrderService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<ServiceOrderModel>> getOrders() async {
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
            'service.order',
            'search_read',
            [],
            {
              'fields': [
                'id',
                'name',
                'order_ref',
                'customer_name',
                'phone',
                'lmd_id',
                'state',
                'lmd_status_id',
              ],
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
      throw Exception(data['error'].toString());
    }

    final result = data['result'];

    if (result is! List) {
      throw Exception('Invalid orders response');
    }

    return result
        .whereType<Map<String, dynamic>>()
        .map(ServiceOrderModel.fromJson)
        .toList();
  }
}
