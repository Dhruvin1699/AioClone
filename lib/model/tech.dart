
class Tech {
  List<TechData>? data;

  Tech({this.data});

  Tech.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TechData>[];
      json['data'].forEach((v) {
        data!.add(new TechData.fromJson(v));
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

class TechData {
  String? id;
  String? techName;
  String? createdOn;
  String? modifiedOn;
  Null? deletedOn;
  Null? isDeleted;
  bool? isEnable;

  TechData(
      {this.id,
        this.techName,
        this.createdOn,
        this.modifiedOn,
        this.deletedOn,
        this.isDeleted,
        this.isEnable});

  TechData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    techName = json['tech_name'];
    createdOn = json['created_on'];
    modifiedOn = json['modified_on'];
    deletedOn = json['deleted_on'];
    isDeleted = json['is_deleted'];
    isEnable = json['is_enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tech_name'] = this.techName;
    data['created_on'] = this.createdOn;
    data['modified_on'] = this.modifiedOn;
    data['deleted_on'] = this.deletedOn;
    data['is_deleted'] = this.isDeleted;
    data['is_enable'] = this.isEnable;
    return data;
  }
}