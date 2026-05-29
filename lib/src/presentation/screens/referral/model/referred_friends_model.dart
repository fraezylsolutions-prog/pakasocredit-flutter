class ReferredFriendsModel {
  bool? status;
  List<ReferredFriendsData>? data;

  ReferredFriendsModel({this.status, this.data});

  ReferredFriendsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ReferredFriendsData>[];
      json['data'].forEach((v) {
        data!.add(ReferredFriendsData.fromJson(v));
      });
    }
  }
}

class ReferredFriendsData {
  String? username;
  String? avatar;
  String? portfolio;
  bool? status;
  String? createdAt;

  ReferredFriendsData({
    this.username,
    this.avatar,
    this.portfolio,
    this.status,
    this.createdAt,
  });

  ReferredFriendsData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    avatar = json['avatar'];
    portfolio = json['portfolio'];
    status = json['status'];
    createdAt = json['created_at'];
  }
}
