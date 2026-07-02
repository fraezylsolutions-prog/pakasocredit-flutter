class AccountListModel {
  bool? status;
  List<AccountListData>? data;

  AccountListModel({this.status, this.data});

  AccountListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AccountListData>[];
      json['data'].forEach((v) {
        data!.add(AccountListData.fromJson(v));
      });
    }
  }
}

class AccountListData {
  int? id;
  String? methodName;
  String? currency;
  Method? method;
  Map<String, dynamic>? fields;

  AccountListData({this.id, this.methodName, this.currency, this.fields});

  AccountListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    methodName = json['method_name'];
    currency = json['currency'];
    method = json['method'] != null ? Method.fromJson(json['method']) : null;
    fields = json['fields'];
  }
}

class Method {
  int? id;
  String? name;
  String? icon;
  String? type;
  int? minWithdraw;
  int? maxWithdraw;
  int? charge;
  double? rate;
  String? chargeType;
  String? time;

  Method({
    this.id,
    this.name,
    this.icon,
    this.type,
    this.minWithdraw,
    this.maxWithdraw,
    this.charge,
    this.rate,
    this.chargeType,
    this.time,
  });

  Method.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    type = json['type'];
    minWithdraw = json['min_withdraw'];
    maxWithdraw = json['max_withdraw'];
    charge = json['charge'];
    rate = json['rate']?.toDouble();
    chargeType = json['charge_type'];
    time = json['time'];
  }
}
