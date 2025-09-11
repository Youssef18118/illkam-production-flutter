import 'package:ilkkam/providers/works/Works.dart';

class Apply {
  String? createdDateTime;
  String? modifiedDateTime;
  int? id;
  int? peopleCount;
  Users? applier;
  int? status;

  Apply(
      {this.createdDateTime,
        this.modifiedDateTime,
        this.id,
        this.peopleCount,
        this.applier,
        this.status});

  Apply.fromJson(Map<String, dynamic> json) {
    createdDateTime = json['createdDateTime'];
    modifiedDateTime = json['modifiedDateTime'];
    id = json['id'];
    peopleCount = json['peopleCount'];
    applier =
    json['applier'] != null ? new Users.fromJson(json['applier']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDateTime'] = this.createdDateTime;
    data['modifiedDateTime'] = this.modifiedDateTime;
    data['id'] = this.id;
    data['peopleCount'] = this.peopleCount;
    if (this.applier != null) {
      data['applier'] = this.applier!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}