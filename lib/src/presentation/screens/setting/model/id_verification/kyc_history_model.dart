class KycHistoryModel {
  bool? status;
  List<KycHistoryData>? data;

  KycHistoryModel({this.status, this.data});

  factory KycHistoryModel.fromJson(Map<String, dynamic> json) {
    var list = <KycHistoryData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        list.add(KycHistoryData.fromJson(v));
      });
    }
    return KycHistoryModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: list,
    );
  }
}

class KycHistoryData {
  int? id;
  int? userId;
  int? kycId;
  String? type;
  Map<String, dynamic>? data;
  String? message;
  int? isValid;
  String? status;
  String? createdAt;
  String? updatedAt;

  KycHistoryData({
    this.id,
    this.userId,
    this.kycId,
    this.type,
    this.data,
    this.message,
    this.isValid,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory KycHistoryData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return KycHistoryData(
      id: toInt(json['id']),
      userId: toInt(json['user_id']),
      kycId: toInt(json['kyc_id']),
      type: json['type']?.toString(),
      data: json['data'] is Map<String, dynamic> ? json['data'] : null,
      message: json['message']?.toString(),
      isValid: toInt(json['is_valid']),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
