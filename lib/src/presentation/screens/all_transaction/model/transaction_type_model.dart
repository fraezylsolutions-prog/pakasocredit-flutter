class TransactionTypeModel {
  bool? status;
  List<TransactionTypeData>? data;

  TransactionTypeModel({this.status, this.data});

  TransactionTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TransactionTypeData>[];
      json['data'].forEach((v) {
        data!.add(TransactionTypeData.fromJson(v));
      });
    }
  }
}

class TransactionTypeData {
  String? name;
  String? value;

  TransactionTypeData({this.name, this.value});

  TransactionTypeData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }
}
