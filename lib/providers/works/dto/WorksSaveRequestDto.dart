import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';

class WorksSaveRequestDto {
  String? workDate;
  String? workHour;
  String? workLocationSi;
  String? workLocationGu;
  String? workLocationDong;
  String? workMainType;
  String? workDetailType;
  List<WorkInfoDetail>? workInfoDetail;
  int? price;
  String? comments;
  int? employerId;
  List<String>? workImages;


  WorksSaveRequestDto(
      {this.workDate,
        this.workHour,
        this.workLocationSi,
        this.workLocationGu,
        this.workLocationDong,
        this.workMainType,
        this.workDetailType,
        this.workInfoDetail,
        this.price,
        this.comments,
        this.workImages,
        this.employerId});

  WorksSaveRequestDto.fromJson(Map<String, dynamic> json) {
    workDate = json['workDate'];
    workHour = json['workHour'];
    workLocationSi = json['workLocationSi'];
    workLocationGu = json['workLocationGu'];
    workLocationDong = json['workLocationDong'];
    workMainType = json['workMainType'];
    workDetailType = json['workDetailType'];
    if (json['workInfoDetail'] != null) {
      workInfoDetail = <WorkInfoDetail>[];
      json['workInfoDetail'].forEach((v) {
        workInfoDetail!.add(new WorkInfoDetail.fromJson(v));
      });
    }
    price = json['price'];
    comments = json['comments'];
    employerId = json['employer_id'];
    workImages = json['workImages'].cast<String>();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workDate'] = this.workDate;
    data['workHour'] = this.workHour;
    data['workLocationSi'] = this.workLocationSi;
    data['workLocationGu'] = this.workLocationGu;
    data['workLocationDong'] = this.workLocationDong;
    data['workMainType'] = this.workMainType;
    data['workDetailType'] = this.workDetailType;
    if (this.workInfoDetail != null) {
      data['workInfoDetail'] =
          this.workInfoDetail!.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['comments'] = this.comments;
    data['employer_id'] = this.employerId;
    data['workImages'] = this.workImages;

    return data;
  }
}
