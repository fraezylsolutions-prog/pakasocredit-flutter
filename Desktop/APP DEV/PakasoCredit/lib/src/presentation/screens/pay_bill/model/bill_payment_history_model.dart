class BillPaymentHistoryModel {
  bool? status;
  List<BillPaymentHistoryData>? data;
  Meta? meta;

  BillPaymentHistoryModel({this.status, this.data, this.meta});

  BillPaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <BillPaymentHistoryData>[];
      json['data'].forEach((v) {
        data!.add(BillPaymentHistoryData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
}

class BillPaymentHistoryData {
  String? serviceName;
  String? serviceType;
  String? amount;
  String? charge;
  String? status;
  String? method;
  String? createdAt;
  Map<dynamic, dynamic>? metadata;

  BillPaymentHistoryData({
    this.serviceName,
    this.serviceType,
    this.amount,
    this.charge,
    this.status,
    this.method,
    this.createdAt,
    this.metadata,
  });

  BillPaymentHistoryData.fromJson(Map<String, dynamic> json) {
    serviceName = json['service_name'];
    serviceType = json['service_type'];
    amount = json['amount'];
    charge = json['charge'];
    status = json['status'];
    method = json['method'];
    createdAt = json['created_at'];
    metadata = json['metadata'];
  }
}

class Meta {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Meta({this.currentPage, this.lastPage, this.perPage, this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }
}
