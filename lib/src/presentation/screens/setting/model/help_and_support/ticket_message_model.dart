class TicketMessageModel {
  bool? status;
  Data? data;

  TicketMessageModel({this.status, this.data});

  TicketMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  Ticket? ticket;
  List<Messages>? messages;

  Data({this.ticket, this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    ticket = json['ticket'] != null ? Ticket.fromJson(json['ticket']) : null;
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }
}

class Ticket {
  int? id;
  String? uuid;
  User? user;
  String? title;
  String? message;
  String? priority;
  String? status;
  String? lastReply;
  List<String>? attachments;
  String? createdAt;

  Ticket({
    this.id,
    this.uuid,
    this.user,
    this.title,
    this.message,
    this.priority,
    this.status,
    this.lastReply,
    this.attachments,
    this.createdAt,
  });

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    title = json['title'];
    message = json['message'];
    priority = json['priority'];
    status = json['status'];
    lastReply = json['last_reply'];
    attachments = json['attachments'].cast<String>();
    createdAt = json['created_at'];
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? avatar;

  User({this.id, this.name, this.email, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
  }
}

class Messages {
  int? id;
  String? message;
  String? avatar;
  String? name;
  String? email;
  bool? isAdmin;
  List<String>? attachments;
  String? createdAt;

  Messages({
    this.id,
    this.message,
    this.avatar,
    this.name,
    this.email,
    this.isAdmin,
    this.attachments,
    this.createdAt,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    avatar = json['avatar'];
    name = json['name'];
    email = json['email'];
    isAdmin = json['is_admin'];
    attachments = json['attachments'].cast<String>();
    createdAt = json['created_at'];
  }
}
