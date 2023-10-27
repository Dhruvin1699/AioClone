class Domain {
  List<DomainData>? data;

  Domain({this.data});

  Domain.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DomainData>[];
      json['data'].forEach((v) {
        data!.add(new DomainData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DomainData {
  String? id;
  String? domainName;
  String? createdAt;
  Null? modifiedOn;
  Null? isDeleted;
  Null? deletedOn;
  bool? isEnable;

  DomainData(
      {this.id,
        this.domainName,
        this.createdAt,
        this.modifiedOn,
        this.isDeleted,
        this.deletedOn,
        this.isEnable});

  DomainData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    domainName = json['domain_name'];
    createdAt = json['created_at'];
    modifiedOn = json['modified_on'];
    isDeleted = json['is_deleted'];
    deletedOn = json['deleted_on'];
    isEnable = json['is_enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['domain_name'] = this.domainName;
    data['created_at'] = this.createdAt;
    data['modified_on'] = this.modifiedOn;
    data['is_deleted'] = this.isDeleted;
    data['deleted_on'] = this.deletedOn;
    data['is_enable'] = this.isEnable;
    return data;
  }
}
