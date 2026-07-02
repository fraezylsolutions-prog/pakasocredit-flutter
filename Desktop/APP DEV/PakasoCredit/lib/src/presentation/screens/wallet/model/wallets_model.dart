class WalletsModel {
  bool? status;
  List<WalletsData>? data;

  WalletsModel({this.status, this.data});

  factory WalletsModel.fromJson(Map<String, dynamic> json) {
    var dataList = <WalletsData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(WalletsData.fromJson(v));
      });
    }
    return WalletsModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class WalletsData {
  int? id;
  String? name;
  String? accountNo;
  String? balance;
  String? code;
  String? symbol;

  WalletsData({
    this.id,
    this.name,
    this.accountNo,
    this.balance,
    this.code,
    this.symbol,
  });

  factory WalletsData.fromJson(Map<String, dynamic> json) {
    return WalletsData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ""),
      name: json['name']?.toString(),
      accountNo: json['account_no']?.toString(),
      balance: json['balance']?.toString(),
      code: json['code']?.toString(),
      symbol: json['symbol']?.toString(),
    );
  }
}
