import 'package:ilkkam/providers/works/Works.dart';

class Chats {
  String? id;
  String? workDate;
  int? price;
  int? workId;
  String? lastChatMsg;
  String? lastChatTime;
  String? workLocation;
  int unreadCount = 0;
  String? address;
  String? workType;
  String? employerName;
  String? employeeName;
  String? employerPhone;
  String? employeePhone;
  String? employerProfile;
  String? employeeProfile;
  bool? employerExist;
  bool? employeeExist;
  int? employerId;
  int? employeeId;
  String? modifiedDateTime;


  Chats(
      {this.id,
        this.workDate,
        this.price,
        this.lastChatMsg,
        this.lastChatTime,
        this.workId,
        this.address,
        this.workType,
        this.workLocation,
        this.employerName,
        this.employeeName,
        this.employerPhone,
        this.employeePhone,
        this.employerProfile,
        this.employeeProfile,
        this.employerExist,
        this.employeeExist,
        this.employerId,
        this.employeeId,
        this.modifiedDateTime
      });

  Chats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workId = json['workId'];
    workDate = json['workDate'];
    price = json['price'];
    lastChatMsg = json['lastChatMsg'];
    lastChatTime = json['lastChatTime'];
    address = json['address'];
    workType = json['workType'];
    workLocation = json['workLocation'];
    employerName = json['employerName'];
    employeeName = json['employeeName'];
    employerPhone = json['employerPhone'];
    employeePhone = json['employeePhone'];
    employerProfile = json['employerProfile'];
    employeeProfile = json['employeeProfile'];
    employerExist = json['employerExist'];
    employeeExist = json['employeeExist'];
    employerId = json['employerId'];
    employeeId = json['employeeId'];
    modifiedDateTime = json['modifiedDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['workId'] = this.workId;
    data['workDate'] = this.workDate;
    data['price'] = this.price;
    data['lastChatMsg'] = this.lastChatMsg;
    data['lastChatTime'] = this.lastChatTime;
    data['address'] = this.address;
    data['workType'] = this.workType;
    data['workLocation'] = this.workLocation;
    data['employerName'] = this.employerName;
    data['employeeName'] = this.employeeName;
    data['employerPhone'] = this.employerPhone;
    data['employeePhone'] = this.employeePhone;
    data['employerProfile'] = this.employerProfile;
    data['employeeProfile'] = this.employeeProfile;
    data['employerExist'] = this.employerExist;
    data['employeeExist'] = this.employeeExist;
    data['employerId'] = this.employerId;
    data['employeeId'] = this.employeeId;
    data['modifiedDateTime'] = this.modifiedDateTime;
    return data;
  }
}
