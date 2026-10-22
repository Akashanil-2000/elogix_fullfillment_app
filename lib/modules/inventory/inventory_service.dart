import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../auth/auth_session.dart';

import 'models/product_sku_model.dart';

class InventoryService {
  final Dio _dio;

  InventoryService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<ProductSkuModel>> getProductSkus() async {
    final userId = AuthSession.userId;
    final username = AuthSession.username;
    final password = AuthSession.password;

    if (userId == null || username == null || password == null) {
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
            'product.sku',
            'search_read',
            [],
            {
              'fields': [
                'id',
                'name',
                'sku_code',
                'merchant_id',
                'local_qty',
                'state',
                'reorder_qty',
              ],
              'limit': 10,
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
      throw Exception('Invalid product SKU response');
    }

    return result
        .whereType<Map<String, dynamic>>()
        .map(ProductSkuModel.fromJson)
        .toList();
  }
}
