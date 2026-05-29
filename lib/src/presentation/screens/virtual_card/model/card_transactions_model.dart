class CardTransactionsModel {
  bool? status;
  List<CardTransactionsData>? data;

  CardTransactionsModel({this.status, this.data});

  CardTransactionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CardTransactionsData>[];
      json['data'].forEach((v) {
        data!.add(CardTransactionsData.fromJson(v));
      });
    }
  }
}

class CardTransactionsData {
  String? id;
  String? created;
  int? amount;
  String? currency;
  String? status;
  MerchantData? merchantData;

  CardTransactionsData({
    this.id,
    this.created,
    this.amount,
    this.currency,
    this.status,
    this.merchantData,
  });

  CardTransactionsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created = json['created'];
    amount = json['amount'];
    currency = json['currency'];
    status = json['status'];
    merchantData =
        json['merchant_data'] != null
            ? MerchantData.fromJson(json['merchant_data'])
            : null;
  }
}

class MerchantData {
  String? name;

  MerchantData({this.name});

  MerchantData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
