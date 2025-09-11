class CreateChatRes {
  int? employerId;
  int? employeeId;
  String? chatRoomId;

  CreateChatRes({this.employerId, this.employeeId, this.chatRoomId});

  CreateChatRes.fromJson(Map<String, dynamic> json) {
    employerId = json['employerId'];
    employeeId = json['employeeId'];
    chatRoomId = json['chatRoomId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employerId'] = this.employerId;
    data['employeeId'] = this.employeeId;
    data['chatRoomId'] = this.chatRoomId;
    return data;
  }
}
