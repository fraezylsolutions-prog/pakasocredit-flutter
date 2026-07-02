class WithdrawHistoryModel {
  List<WithdrawHistoryData>? data;
  Links? links;
  Meta? meta;

  WithdrawHistoryModel({this.data, this.links, this.meta});

  WithdrawHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WithdrawHistoryData>[];
      json['data'].forEach((v) {
        data!.add(WithdrawHistoryData.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
}

class WithdrawHistoryData {
  String? description;
  String? tnx;
  bool? isPlus;
  String? type;
  String? amount;
  String? charge;
  String? finalAmount;
  String? status;
  String? method;
  String? createdAt;

  WithdrawHistoryData({
    this.description,
    this.tnx,
    this.isPlus,
    this.type,
    this.amount,
    this.charge,
    this.finalAmount,
    this.status,
    this.method,
    this.createdAt,
  });

  WithdrawHistoryData.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    tnx = json['tnx'];
    isPlus = json['is_plus'];
    type = json['type'];
    amount = json['amount'];
    charge = json['charge'];
    finalAmount = json['final_amount'];
    status = json['status'];
    method = json['method'];
    createdAt = json['created_at'];
  }
}

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<LinksData>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <LinksData>[];
      json['links'].forEach((v) {
        links!.add(LinksData.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }
}

class LinksData {
  String? url;
  String? label;
  bool? active;

  LinksData({this.url, this.label, this.active});

  LinksData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }
}
