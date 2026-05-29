class CardHoldersModel {
  bool? status;
  List<CardHoldersData>? data;

  CardHoldersModel({this.status, this.data});

  CardHoldersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CardHoldersData>[];
      json['data'].forEach((v) {
        data!.add(CardHoldersData.fromJson(v));
      });
    }
  }
}

class CardHoldersData {
  int? id;
  int? userId;
  String? cardHolderId;
  String? provider;
  String? name;
  String? email;
  String? phoneNumber;
  String? status;
  String? type;
  String? address;
  String? country;
  String? city;
  String? state;
  String? postalCode;
  String? createdAt;
  String? updatedAt;

  CardHoldersData({
    this.id,
    this.userId,
    this.cardHolderId,
    this.provider,
    this.name,
    this.email,
    this.phoneNumber,
    this.status,
    this.type,
    this.address,
    this.country,
    this.city,
    this.state,
    this.postalCode,
    this.createdAt,
    this.updatedAt,
  });

  CardHoldersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cardHolderId = json['card_holder_id'];
    provider = json['provider'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    type = json['type'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postal_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
