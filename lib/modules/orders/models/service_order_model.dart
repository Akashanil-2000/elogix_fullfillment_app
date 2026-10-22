import '../../../core/utils/json_parser.dart';

class ServiceOrderModel {
  final int id;
  final String name;
  final String orderRef;
  final String customerName;
  final String phone;

  final int? lmdId;
  final String lmdName;
  final String state;

  final int? lmdStatusId;
  final String lmdStatusName;

  const ServiceOrderModel({
    required this.id,
    required this.name,
    required this.orderRef,
    required this.customerName,
    required this.phone,
    required this.lmdId,
    required this.lmdName,
    required this.state,
    required this.lmdStatusId,
    required this.lmdStatusName,
  });

  factory ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return ServiceOrderModel(
      id: JsonParser.integer(json['id']),
      name: JsonParser.string(json['name']),
      orderRef: JsonParser.string(json['order_ref']),
      customerName: JsonParser.string(json['customer_name']),
      phone: JsonParser.string(json['phone']),
      lmdId: JsonParser.many2OneId(json['lmd_id']),
      lmdName: JsonParser.many2OneName(json['lmd_id']),
      state: JsonParser.string(json['state']),
      lmdStatusId: JsonParser.many2OneId(json['lmd_status_id']),
      lmdStatusName: JsonParser.many2OneName(json['lmd_status_id']),
    );
  }
}
