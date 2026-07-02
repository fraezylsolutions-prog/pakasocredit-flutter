class KycModel {
  bool? status;
  List<KycData>? data;

  KycModel({this.status, this.data});

  factory KycModel.fromJson(Map<String, dynamic> json) {
    var dataList = <KycData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(KycData.fromJson(v));
      });
    }
    return KycModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class KycData {
  int? id;
  String? name;
  String? fields;
  int? status;
  String? createdAt;
  String? updatedAt;

  KycData({
    this.id,
    this.name,
    this.fields,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory KycData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return KycData(
      id: toInt(json['id']),
      name: json['name']?.toString(),
      fields: json['fields']?.toString(),
      status: toInt(json['status']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
