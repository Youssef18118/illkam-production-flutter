class SavePostsRequestDto {
  String? title;
  String? contents;
  int? writer;
  int? categoryId;
  List<String>? images;

  SavePostsRequestDto(
      {this.title, this.contents, this.writer, this.categoryId, this.images});

  SavePostsRequestDto.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    contents = json['contents'];
    writer = json['writer'];
    categoryId = json['category_id'];
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['contents'] = this.contents;
    data['writer'] = this.writer;
    data['category_id'] = this.categoryId;
    data['images'] = this.images;
    return data;
  }
}
