class TransactionsModel {
  List<TransactionsData>? data;
  Links? links;
  Meta? meta;

  TransactionsModel({this.data, this.links, this.meta});

  factory TransactionsModel.fromJson(Map<String, dynamic> json) {
    var dataList = <TransactionsData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(TransactionsData.fromJson(v));
      });
    }
    return TransactionsModel(
      data: dataList,
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class TransactionsData {
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

  TransactionsData({
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

  factory TransactionsData.fromJson(Map<String, dynamic> json) {
    bool toBool(dynamic v) => v == true || v == 1 || v == "1" || v?.toString().toLowerCase() == "true";
    return TransactionsData(
      description: json['description']?.toString(),
      tnx: json['tnx']?.toString(),
      isPlus: toBool(json['is_plus']),
      type: json['type']?.toString(),
      amount: json['amount']?.toString(),
      charge: json['charge']?.toString(),
      finalAmount: json['final_amount']?.toString(),
      status: json['status']?.toString(),
      method: json['method']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first']?.toString(),
      last: json['last']?.toString(),
      prev: json['prev']?.toString(),
      next: json['next']?.toString(),
    );
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

  factory Meta.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? "");
    var linksList = <LinksData>[];
    if (json['links'] != null) {
      json['links'].forEach((v) {
        linksList.add(LinksData.fromJson(v));
      });
    }
    return Meta(
      currentPage: toInt(json['current_page']),
      from: toInt(json['from']),
      lastPage: toInt(json['last_page']),
      links: linksList,
      path: json['path']?.toString(),
      perPage: toInt(json['per_page']),
      to: toInt(json['to']),
      total: toInt(json['total']),
    );
  }
}

class LinksData {
  String? url;
  String? label;
  bool? active;

  LinksData({this.url, this.label, this.active});

  factory LinksData.fromJson(Map<String, dynamic> json) {
    return LinksData(
      url: json['url']?.toString(),
      label: json['label']?.toString(),
      active: json['active'] == true || json['active'] == 1 || json['active'] == "1",
    );
  }
}
