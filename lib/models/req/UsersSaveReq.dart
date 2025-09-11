class UserSaveReq {
  String? name;
  String? businessNumber;
  String? businessAddress;
  String? phoneNumber;
  String? email;
  String? password;
  String? businessCertification;
  String? fcmToken;

  UserSaveReq(
      {this.name,
        this.businessNumber,
        this.businessAddress,
        this.phoneNumber,
        this.businessCertification,
        this.password,
        this.fcmToken,
        this.email});

  UserSaveReq.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    businessNumber = json['businessNumber'];
    businessAddress = json['businessAddress'];
    businessCertification = json['businessCertification'];
    phoneNumber = json['phoneNumber'];
    password=json['password'];
    email = json['email'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['businessNumber'] = this.businessNumber;
    data['businessAddress'] = this.businessAddress;
    data['businessCertification'] = this.businessCertification;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['password'] = this.password;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}
