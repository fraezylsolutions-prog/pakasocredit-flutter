class InstallmentListModel {
  bool? status;
  List<InstallmentListData>? data;

  InstallmentListModel({this.status, this.data});

  InstallmentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <InstallmentListData>[];
      json['data'].forEach((v) {
        data!.add(InstallmentListData.fromJson(v));
      });
    }
  }
}

class InstallmentListData {
  int? id;
  int? dpsId;
  String? installmentDate;
  String? givenDate;
  int? deferment;
  String? paidAmount;
  String? charge;
  String? finalAmount;
  String? createdAt;
  String? updatedAt;

  InstallmentListData({
    this.id,
    this.dpsId,
    this.installmentDate,
    this.givenDate,
    this.deferment,
    this.paidAmount,
    this.charge,
    this.finalAmount,
    this.createdAt,
    this.updatedAt,
  });

  InstallmentListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dpsId = json['dps_id'];
    installmentDate = json['installment_date'];
    givenDate = json['given_date'];
    deferment = json['deferment'];
    paidAmount = json['paid_amount'];
    charge = json['charge'];
    finalAmount = json['final_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
