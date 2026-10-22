import '../../../core/utils/json_parser.dart';

class TrackingLineModel {
  final int id;
  final String remarks;
  final int? lmdStatusId;
  final String lmdStatusName;
  final String dateUpdate;

  const TrackingLineModel({
    required this.id,
    required this.remarks,
    required this.lmdStatusId,
    required this.lmdStatusName,
    required this.dateUpdate,
  });

  factory TrackingLineModel.fromJson(Map<String, dynamic> json) {
    return TrackingLineModel(
      id: JsonParser.integer(json['id']),
      remarks: JsonParser.string(json['remarks']),
      lmdStatusId: JsonParser.many2OneId(json['lmd_status_id']),
      lmdStatusName: JsonParser.many2OneName(json['lmd_status_id']),
      dateUpdate: JsonParser.string(json['date_update']),
    );
  }
}
