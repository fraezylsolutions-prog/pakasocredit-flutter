class TicketHistoryModel {
  final bool? status;
  final List<TicketHistoryData>? data;
  final Meta? meta;

  TicketHistoryModel({this.status, this.data, this.meta});

  factory TicketHistoryModel.fromJson(Map<String, dynamic> json) {
    return TicketHistoryModel(
      status: json['status'],
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map((v) => TicketHistoryData.fromJson(v))
                  .toList()
              : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class TicketHistoryData {
  final int? id;
  final String? uuid;
  final String? title;
  final String? message;
  final String? priority;
  final String? status;
  final String? lastReply;
  final List<String>? attachments;
  final String? createdAt;

  TicketHistoryData({
    this.id,
    this.uuid,
    this.title,
    this.message,
    this.priority,
    this.status,
    this.lastReply,
    this.attachments,
    this.createdAt,
  });

  factory TicketHistoryData.fromJson(Map<String, dynamic> json) {
    return TicketHistoryData(
      id: json['id'],
      uuid: json['uuid'],
      title: json['title'],
      message: json['message'],
      priority: json['priority'],
      status: json['status'],
      lastReply: json['last_reply'],
      attachments:
          json['attachments'] != null
              ? List<String>.from(json['attachments'])
              : null,
      createdAt: json['created_at'],
    );
  }
}

class Meta {
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  Meta({this.currentPage, this.lastPage, this.perPage, this.total});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}
