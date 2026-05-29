class CurrenciesModel {
  bool? status;
  List<CurrenciesData>? data;

  CurrenciesModel({this.status, this.data});

  factory CurrenciesModel.fromJson(Map<String, dynamic> json) {
    var dataList = <CurrenciesData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(CurrenciesData.fromJson(v));
      });
    }
    return CurrenciesModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class CurrenciesData {
  int? id;
  String? name;
  String? code;
  String? symbol;
  double? rate;
  String? createdAt;
  String? updatedAt;

  CurrenciesData({
    this.id,
    this.name,
    this.code,
    this.symbol,
    this.rate,
    this.createdAt,
    this.updatedAt,
  });

  factory CurrenciesData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return CurrenciesData(
      id: toInt(json['id']),
      name: json['name']?.toString(),
      code: json['code']?.toString(),
      symbol: json['symbol']?.toString(),
      rate: toDouble(json['rate']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
