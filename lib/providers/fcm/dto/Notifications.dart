import 'package:ilkkam/providers/works/Works.dart';

class Notifications {
  String? createdDateTime;
  String? modifiedDateTime;
  int? id;
  Users? user;
  String? title;
  String? body;
  String? routeName;
  String? targetPageId;

  Notifications(
      {this.createdDateTime,
        this.modifiedDateTime,
        this.id,
        this.user,
        this.title,
        this.targetPageId,
        this.routeName,
        this.body});

  Notifications.fromJson(Map<String, dynamic> json) {
    createdDateTime = json['createdDateTime'];
    modifiedDateTime = json['modifiedDateTime'];
    id = json['id'];
    user = json['user'] != null ? new Users.fromJson(json['user']) : null;
    title = json['title'];

    body = json['body'];
    routeName = json['routeName'];
    targetPageId = json['targetPageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDateTime'] = this.createdDateTime;
    data['modifiedDateTime'] = this.modifiedDateTime;
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['title'] = this.title;

    data['body'] = this.body;
    data['routeName'] = this.routeName;
    data['targetPageId'] = this.targetPageId;
    return data;
  }
}