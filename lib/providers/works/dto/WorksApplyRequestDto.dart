class WorkApplyRequestDto {
  int? peopleCount;
  int? applierId;
  int? workId;

  WorkApplyRequestDto({this.peopleCount, this.applierId, this.workId});

  WorkApplyRequestDto.fromJson(Map<String, dynamic> json) {
    peopleCount = json['people_count'];
    applierId = json['applier_id'];
    workId = json['work_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['people_count'] = this.peopleCount;
    data['applier_id'] = this.applierId;
    data['work_id'] = this.workId;
    return data;
  }
}
