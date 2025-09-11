class UnreadRoomInfo {
  String? roomId;
  int? unreadCount;
  String? lastChat;
  String? lastChatTime;

  UnreadRoomInfo({this.roomId, this.unreadCount});

  UnreadRoomInfo.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['unreadCount'] = this.unreadCount;
    return data;
  }
}
