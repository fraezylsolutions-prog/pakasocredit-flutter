class NotificationModel {
  bool? status;
  NotificationData? data;
  Meta? meta;

  NotificationModel({this.status, this.data, this.meta});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data =
        json['data'] != null ? NotificationData.fromJson(json['data']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
}

class NotificationData {
  List<Notifications>? today;
  List<Notifications>? yesterday;
  Map<String, List<Notifications>>? otherDates;

  NotificationData({this.today, this.yesterday, this.otherDates});

  NotificationData.fromJson(Map<String, dynamic> json) {
    if (json['Today'] != null) {
      today = <Notifications>[];
      json['Today'].forEach((v) {
        today!.add(Notifications.fromJson(v));
      });
    }
    if (json['Yesterday'] != null) {
      yesterday = <Notifications>[];
      json['Yesterday'].forEach((v) {
        yesterday!.add(Notifications.fromJson(v));
      });
    }
    otherDates = {};
    json.forEach((key, value) {
      if (key != 'Today' && key != 'Yesterday' && value is List) {
        otherDates![key] =
            value.map<Notifications>((v) => Notifications.fromJson(v)).toList();
      }
    });
  }
}

class Notifications {
  int? id;
  String? title;
  bool? isRead;
  String? createdAt;

  Notifications({this.id, this.title, this.isRead, this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
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
