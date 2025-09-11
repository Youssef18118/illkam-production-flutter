import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';

class WorksUdateRequestDto {
  String? workDate;
  String? workHour;
  int? price;

  WorksUdateRequestDto(
      {this.workDate,
        this.workHour,
        this.price,
        });

  WorksUdateRequestDto.fromJson(Map<String, dynamic> json) {
    workDate = json['workDate'];
    workHour = json['workHour'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workDate'] = this.workDate;
    data['workHour'] = this.workHour;
    data['price'] = this.price;
    return data;
  }
}
