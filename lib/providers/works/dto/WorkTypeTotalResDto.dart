import 'package:ilkkam/models/workTypes/WorkTypeDetails.dart';

class WorkTypes {
  int? id;
  String? name;
  List<WorkInfoDetail>? workInfoDetail;
  List<WorkTypeDetails>? workTypeDetails;

  WorkTypes(
      {this.id, this.name, this.workInfoDetail, this.workTypeDetails});

  WorkTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['workInfoDetail'] != null) {
      workInfoDetail = <WorkInfoDetail>[];
      json['workInfoDetail'].forEach((v) {
        workInfoDetail!.add(new WorkInfoDetail.fromJson(v));
      });
    }
    if (json['workTypeDetails'] != null) {
      workTypeDetails = <WorkTypeDetails>[];
      json['workTypeDetails'].forEach((v) {
        workTypeDetails!.add(new WorkTypeDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.workInfoDetail != null) {
      data['workInfoDetail'] =
          this.workInfoDetail!.map((v) => v.toJson()).toList();
    }
    if (this.workTypeDetails != null) {
      data['workTypeDetails'] =
          this.workTypeDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkInfoDetail {
  String? name;
  String? inputType;
  List<String>? options;

  WorkInfoDetail({this.name, this.inputType, this.options});

  WorkInfoDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    inputType = json['inputType'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['inputType'] = this.inputType;
    data['options'] = this.options;
    return data;
  }
}

