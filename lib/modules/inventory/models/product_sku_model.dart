import '../../../core/utils/json_parser.dart';

class ProductSkuModel {
  final int id;
  final String name;
  final String skuCode;
  final int? merchantId;
  final String merchantName;
  final double localQty;
  final String state;

  const ProductSkuModel({
    required this.id,
    required this.name,
    required this.skuCode,
    required this.merchantId,
    required this.merchantName,
    required this.localQty,
    required this.state,
  });

  factory ProductSkuModel.fromJson(Map<String, dynamic> json) {
    return ProductSkuModel(
      id: JsonParser.integer(json['id']),
      name: JsonParser.string(json['name']),
      skuCode: JsonParser.string(json['sku_code']),
      merchantId: JsonParser.many2OneId(json['merchant_id']),
      merchantName: JsonParser.many2OneName(json['merchant_id']),
      localQty: JsonParser.decimal(json['local_qty']),
      state: JsonParser.string(json['state']),
    );
  }
}
