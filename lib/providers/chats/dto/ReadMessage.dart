class ReadMessage {
  String? roomId;
  int? userId;

  ReadMessage({this.roomId, this.userId});

  ReadMessage.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['userId'] = this.userId;
    return data;
  }
}
