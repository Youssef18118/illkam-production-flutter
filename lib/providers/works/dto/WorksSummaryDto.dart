class WorksSummaryDto {
  String? date;
  int? workCount;

  WorksSummaryDto({this.date, this.workCount});

  WorksSummaryDto.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    workCount = json['workCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['workCount'] = this.workCount;
    return data;
  }
}
