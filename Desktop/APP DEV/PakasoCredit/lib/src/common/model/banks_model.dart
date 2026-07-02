class BanksModel {
  bool? status;
  List<BanksData>? data;

  BanksModel({this.status, this.data});

  factory BanksModel.fromJson(Map<String, dynamic> json) {
    var list = <BanksData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        list.add(BanksData.fromJson(v));
      });
    }
    return BanksModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: list,
    );
  }
}

class BanksData {
  int? id;
  String? name;
  String? processingTime;
  String? chargeType;
  int? charge;
  int? minimumTransfer;
  int? maximumTransfer;

  BanksData({
    this.id,
    this.name,
    this.processingTime,
    this.chargeType,
    this.charge,
    this.minimumTransfer,
    this.maximumTransfer,
  });

  factory BanksData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) => (v is int) ? v : int.tryParse(v?.toString() ?? "");
    return BanksData(
      id: toInt(json['id']),
      name: json['name']?.toString(),
      processingTime: json['processing_time']?.toString(),
      chargeType: json['charge_type']?.toString(),
      charge: toInt(json['charge']),
      minimumTransfer: toInt(json['minimum_transfer']),
      maximumTransfer: toInt(json['maximum_transfer']),
    );
  }
}
