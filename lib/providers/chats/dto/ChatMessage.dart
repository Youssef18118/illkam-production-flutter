class ChatMessage {
  int? id;
  String? roomId;
  String? authorId;
  int? receiverId;
  String? message;
  int? readCount;
  String? createdAt;

  ChatMessage(
      {this.id,
        this.roomId,
        this.authorId,
        this.receiverId,
        this.message,
        this.readCount,
        this.createdAt});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['roomId'];
    authorId = json['authorId'];
    receiverId = int.parse(json['receiverId'].toString());
    message = json['message'];
    readCount = json['readCount'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roomId'] = this.roomId;
    data['authorId'] = this.authorId;
    data['receiverId'] = this.receiverId;
    data['message'] = this.message;
    data['readCount'] = this.readCount;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
