class WorkReviewSaveRequestDto {

  int? writer;
  int? target;
  String? contents;
  String? image;
  int? starCount;

  WorkReviewSaveRequestDto(
      {
        this.writer,
        this.target,
        this.contents,
        this.image,
        this.starCount});

  WorkReviewSaveRequestDto.fromJson(Map<String, dynamic> json) {

    writer = json['writer'];
    target = json['target'];
    contents = json['contents'];
    image = json['image'];
    starCount = json['starCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['writer'] = this.writer;
    data['target'] = this.target;
    data['contents'] = this.contents;
    data['image'] = this.image;
    data['starCount'] = this.starCount;
    return data;
  }
}
