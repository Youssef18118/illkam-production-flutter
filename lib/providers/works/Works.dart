import 'package:ilkkam/models/workTypes/WorkTypeDetails.dart';
import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';
import 'package:ilkkam/providers/applies/dto/Apply.dart';

class Work {
  int? id;
  String? createdDateTime;
  String? modifiedDateTime;
  String? workDate;
  String? workHour;
  WorkTypeDetails? workTypeDetails;
  String? workLocationSi;
  String? workLocationGu;
  String? workLocationDong;
  WorkTypes? workTypes;
  List<WorkInfoDetail>? workInfoDetail;
  List<String>? workImages;
  int? price;
  String? comments;
  bool? isConfirmed;
  bool? isReviewed;
  Users? employer;
  Users? employee;
  List<Apply>? appliesList;
  List<WorkReviews>? workReviews;
  bool? didEmployeeReviewed;

  Work(
      {this.id,
      this.createdDateTime,
      this.modifiedDateTime,
      this.workDate,
      this.workHour,
      this.workTypeDetails,
      this.workLocationSi,
      this.workLocationGu,
      this.workLocationDong,
      this.workTypes,
      this.workInfoDetail,
      this.workImages,
      this.isConfirmed,
        this.isReviewed,
      this.price,
      this.comments,
      this.employer,
      this.appliesList,this.didEmployeeReviewed
      });

  Work.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDateTime = json['createdDateTime'];
    modifiedDateTime = json['modifiedDateTime'];
    workDate = json['workDate'];
    workHour = json['workHour'];
    workTypeDetails = json['workTypeDetails'] != null
        ? new WorkTypeDetails.fromJson(json['workTypeDetails'])
        : null;
    workLocationSi = json['workLocationSi'];
    workLocationGu = json['workLocationGu'];
    workLocationDong = json['workLocationDong'];
    isConfirmed = json['isConfirmed'];
    isReviewed = json['isReviewed'];
    didEmployeeReviewed = json['didEmployeeReviewed'];
    workTypes = json['workTypes'] != null
        ? new WorkTypes.fromJson(json['workTypes'])
        : null;
    if (json['workInfoDetail'] != null) {
      workInfoDetail = <WorkInfoDetail>[];
      json['workInfoDetail'].forEach((v) {
        workInfoDetail!.add(new WorkInfoDetail.fromJson(v));
      });
    }

    if (json['workImages'] != null) {
      workImages = <String>[];
      json['workImages'].forEach((v) {
        workImages!.add(v);
      });
    }

    price = json['price'];
    comments = json['comments'];
    employer =
        json['employer'] != null ? new Users.fromJson(json['employer']) : null;
    employee =
    json['employee'] != null ? new Users.fromJson(json['employee']) : null;
    if (json['appliesList'] != null) {
      appliesList = <Apply>[];
      json['appliesList'].forEach((v) {
        appliesList!.add(new Apply.fromJson(v));
      });
    }
    if (json['workReviews'] != null) {
      workReviews = <WorkReviews>[];
      json['workReviews'].forEach((v) {
        workReviews!.add(new WorkReviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdDateTime'] = this.createdDateTime;
    data['modifiedDateTime'] = this.modifiedDateTime;
    data['workDate'] = this.workDate;
    data['workHour'] = this.workHour;
    if (this.workTypeDetails != null) {
      data['workTypeDetails'] = this.workTypeDetails!.toJson();
    }
    data['workLocationSi'] = this.workLocationSi;
    data['workLocationGu'] = this.workLocationGu;

    data['isConfirmed'] = this.isConfirmed;
    data['isReviewed'] = this.isReviewed;
    data['didEmployeeReviewed'] = this.didEmployeeReviewed;
    data['workLocationDong'] = this.workLocationDong;
    data['workImages'] = this.workImages;

    if (this.workTypes != null) {
      data['workTypes'] = this.workTypes!.toJson();
    }
    if (this.workInfoDetail != null) {
      data['workInfoDetail'] =
          this.workInfoDetail!.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['comments'] = this.comments;
    if (this.employer != null) {
      data['employer'] = this.employer!.toJson();
    }
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    if (this.appliesList != null) {
      data['appliesList'] = this.appliesList!.map((v) => v.toJson()).toList();
    }
    if (this.workReviews != null) {
      data['workReviews'] = this.workReviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? createdDateTime;
  String? modifiedDateTime;
  int? id;
  String? name;
  String? phoneNumber;
  String? businessNumber;
  String? email;
  bool? isApproved;
  double? rating;
  int? commentCount;
  String? approveDate;
  int? reviewCount;
  String? businessAddress;
  String? businessCertification;
  List<WorkReviews>? reviews;

  Users(
      {this.createdDateTime,
      this.modifiedDateTime,
      this.id,
      this.name,
      this.phoneNumber,
      this.businessNumber,
      this.email,
      this.isApproved,
      this.approveDate,this.reviewCount,
      this.rating,
      this.commentCount,
      this.businessAddress,
      this.reviews,
      this.businessCertification});

  Users.fromJson(Map<String, dynamic> json) {
    createdDateTime = json['createdDateTime'];
    modifiedDateTime = json['modifiedDateTime'];
    id = json['id'];
    name = json['name'];
    reviewCount = json['reviewCount'];
    phoneNumber = json['phoneNumber'];
    businessNumber = json['businessNumber'];
    email = json['email'];
    isApproved = json['isApproved'];
    if (json['reviews'] != null) {
      reviews = <WorkReviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new WorkReviews.fromJson(v));
      });
    }
    rating = json['rating'];
    commentCount = json['commentCount'];
    approveDate = json['approveDate'];
    businessAddress = json['businessAddress'];
    businessCertification = json['businessCertification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDateTime'] = this.createdDateTime;
    data['modifiedDateTime'] = this.modifiedDateTime;
    data['id'] = this.id;
    data['reviewCount'] = this.reviewCount;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['businessNumber'] = this.businessNumber;
    data['email'] = this.email;
    data['rating'] = this.rating;
    data['commentCount'] = this.commentCount;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    data['isApproved'] = this.isApproved;
    data['approveDate'] = this.approveDate;
    data['businessAddress'] = this.businessAddress;
    data['businessCertification'] = this.businessCertification;
    return data;
  }
}

class WorkReviews {
  String? createdDateTime;
  String? modifiedDateTime;
  int? id;
  int? work_id;
  Users? employee;
  Users? employer;
  String? contents;
  String? image;
  int? starCount;
  Users? writer;

  WorkReviews(
      {this.createdDateTime,
      this.modifiedDateTime,
      this.id,
      this.employee,
      this.employer,
      this.work_id,
      this.contents,
      this.image,
      this.starCount,
      this.writer});

  WorkReviews.fromJson(Map<String, dynamic> json) {
    createdDateTime = json['createdDateTime'];
    modifiedDateTime = json['modifiedDateTime'];
    id = json['id'];
    work_id = json['work_id'];
    employee =
        json['employee'] != null ? new Users.fromJson(json['employee']) : null;
    employer =
        json['employer'] != null ? new Users.fromJson(json['employer']) : null;
    contents = json['contents'];
    image = json['image'];
    starCount = json['starCount'];
    writer = json['writer'] != null ? new Users.fromJson(json['writer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDateTime'] = this.createdDateTime;
    data['modifiedDateTime'] = this.modifiedDateTime;
    data['id'] = this.id;
    data['work_id'] = this.work_id;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    if (this.employer != null) {
      data['employer'] = this.employer!.toJson();
    }
    data['contents'] = this.contents;
    data['image'] = this.image;
    data['starCount'] = this.starCount;
    if (this.writer != null) {
      data['writer'] = this.writer!.toJson();
    }
    return data;
  }
}
