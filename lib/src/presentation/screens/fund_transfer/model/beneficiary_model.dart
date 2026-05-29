class BeneficiaryModel {
  bool? status;
  List<BeneficiaryData>? data;

  BeneficiaryModel({this.status, this.data});

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    var dataList = <BeneficiaryData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(BeneficiaryData.fromJson(v));
      });
    }
    return BeneficiaryModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class BeneficiaryData {
  int? id;
  int? bankId;
  int? userId;
  String? accountNumber;
  String? accountName;
  String? branchName;
  String? nickName;
  String? createdAt;
  String? updatedAt;

  BeneficiaryData({
    this.id,
    this.bankId,
    this.userId,
    this.accountNumber,
    this.accountName,
    this.branchName,
    this.nickName,
    this.createdAt,
    this.updatedAt,
  });

  factory BeneficiaryData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return BeneficiaryData(
      id: toInt(json['id']),
      bankId: toInt(json['bank_id']),
      userId: toInt(json['user_id']),
      accountNumber: json['account_number']?.toString(),
      accountName: json['account_name']?.toString(),
      branchName: json['branch_name']?.toString(),
      nickName: json['nick_name']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
