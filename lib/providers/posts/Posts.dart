import 'package:ilkkam/providers/works/Works.dart';

class Posts {
  int? id;
  String? createdDateTime;
  String? modifiedDateTime;
  String? title;
  String? contents;
  Users? writer;
  Category? category;
  List<String>? images;
  List<Replies>? replies;

  Posts(
      {this.id,
        this.createdDateTime,
        this.modifiedDateTime,
        this.title,
        this.contents,
        this.writer,
        this.category,
        this.images,
        this.replies});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDateTime = json['createdDateTime'];
    modifiedDateTime = json['modifiedDateTime'];
    title = json['title'];
    contents = json['contents'];
    images = json['images'].cast<String>();
    writer =
    json['writer'] != null ? new Users.fromJson(json['writer']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdDateTime'] = this.createdDateTime;
    data['modifiedDateTime'] = this.modifiedDateTime;
    data['title'] = this.title;
    data['images'] = this.images;
    data['contents'] = this.contents;
    if (this.writer != null) {
      data['writer'] = this.writer!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Replies {
  int? id;
  Users? writer;
  String? contents;

  Replies({this.id, this.writer, this.contents});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    writer =
    json['writer'] != null ? new Users.fromJson(json['writer']) : null;
    contents = json['contents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.writer != null) {
      data['writer'] = this.writer!.toJson();
    }
    data['contents'] = this.contents;
    return data;
  }
}
