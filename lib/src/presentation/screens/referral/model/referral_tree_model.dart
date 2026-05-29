class ReferralTreeModel {
  final bool? status;
  final Data? data;

  ReferralTreeModel({this.status, this.data});

  factory ReferralTreeModel.fromJson(Map<String, dynamic> json) {
    return ReferralTreeModel(
      status: json['status'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  final int? id;
  final String? name;
  final String? avatar;
  final bool? isMe;
  final List<Child>? children;

  Data({this.id, this.name, this.avatar, this.isMe, this.children});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      isMe: json['is_me'],
      children:
          json['children'] != null
              ? List<Child>.from(json['children'].map((x) => Child.fromJson(x)))
              : null,
    );
  }
}

class Child {
  final int? id;
  final String? name;
  final String? avatar;
  final List<Child>? children;

  Child({this.id, this.name, this.avatar, this.children});

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      children:
          json['children'] != null
              ? List<Child>.from(json['children'].map((x) => Child.fromJson(x)))
              : null,
    );
  }
}
