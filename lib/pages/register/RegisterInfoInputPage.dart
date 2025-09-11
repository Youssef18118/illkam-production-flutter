import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/apis/usersAPI.dart';
import 'package:ilkkam/models/req/UsersSaveReq.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/utils/formatters.dart';
import 'package:ilkkam/utils/imagePicker.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:ilkkam/widgets/ImagePickerWidget.dart';
import 'package:ilkkam/widgets/TextTitleBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterInfoInputPage extends StatefulWidget {
  const RegisterInfoInputPage({super.key});

  static const routeName = "/RegisterInfoInputPage";

  @override
  State<RegisterInfoInputPage> createState() => _RegisterInfoInputPageState();
}

class _RegisterInfoInputPageState extends State<RegisterInfoInputPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TextEditingController nameC = TextEditingController();
  TextEditingController businessNumC = TextEditingController();
  TextEditingController businessAddC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordCheckC = TextEditingController();

  // 이미지 리스트
  List<String> imageURLs = [];
  UsersService usersService = UsersService();
  bool isImageUploading = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserController>(context);
    return Scaffold(
      appBar: TextTitleBar(title: "가입하기"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Form(
              key: _formKey,

                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // direction: Axis.vertical,
              // spacing: 20,
              children: [
                IkTextField(
                  placeholder: "이메일 주소 입력",
                  label: "이메일 주소 (필수)",
                  controller: emailC,
                  formatters: [EmailFormatter()],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일 주소를 입력해주세요.';
                    }
                    return null;
                  },

                ),
                SizedBox(
                  height: 20,
                ),
                IkTextField(
                  placeholder: "8자 이상의 비밀번호",
                  label: "비밀번호 (필수)",
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordC,
                  formatters: [EmailFormatter()],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    if (value.length < 8) {
                      return '비밀번호는 8자 이상이어야 합니다.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                IkTextField(
                  placeholder: "8자 이상의 비밀번호",
                  keyboardType: TextInputType.visiblePassword,
                  label: "비밀번호 확인 (필수)",
                  controller: passwordCheckC,
                  formatters: [EmailFormatter()],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호 확인을 입력해주세요.';
                    }
                    if (value != passwordC.text) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                IkTextField(
                  placeholder: "예시) 클린솔루션",
                  label: "상호/이름 (필수)",
                  controller: nameC,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '상호/이름을 입력해주세요.';
                    }
                    return null;
                  },
                  // formatters: [NameFormatter()],
                ),
                SizedBox(
                  height: 20,
                ),
                IkTextField(
                  placeholder: "사업자 번호를 입력해주세요.",
                  label: "사업자 번호 (선택)",
                  controller: businessNumC,
                  formatters: [BusinessNumberFormatter()],
                ),
                SizedBox(
                  height: 20,
                ),
                IkTextField(
                  placeholder: "010-0000-0000",
                  label: "전화번호 (필수)",
                  controller: phoneC,
                  formatters: [PhoneNumberFormatter()],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '전화번호를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),

                IkTextField(
                  placeholder: "사업자 주소를 입력해주세요.",
                  label: "사업자 주소 (필수)",
                  controller: businessAddC,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '사업자 주소를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ImagePickerWidget(
                  label: "사업자 등록증 또는 명함 (필수)",
                  length: 1,
                  onDelete: (int idx){
                    setState(() {
                      imageURLs = [];
                    });
                  },
                  count: imageURLs.length,
                  onTap: () async {
                    setState(() {
                      isImageUploading = true;
                    });
                    String? imgURL = await pickImage(PickUsageType.PROFILE);
                    if (imgURL != null) {
                      setState(() {
                        imageURLs = [imgURL];
                        // imageURLs.add(imgURL);
                      });
                    }
                    setState(() {
                      isImageUploading = false;
                    });
                  },
                  img: imageURLs,
                  isImageUploading: isImageUploading,
                ),
                SizedBox(height: 20,),
                // _companyPicture(),

                SizedBox(
                  height: 60,
                ),
                IKCommonBtn(
                    title: "등록하기",
                    onTap: () async {
                      try {
                        if(_formKey.currentState?.validate() ?? false){
                          UserSaveReq req = UserSaveReq(
                              name: nameC.value.text,
                              businessAddress: businessAddC.value.text,
                              businessNumber: businessNumC.value.text,
                              email: emailC.value.text,
                              password: passwordC.value.text,
                              phoneNumber: phoneC.value.text,
                              businessCertification: imageURLs[0]
                          );
                          int userId = await usersService.register(req);
                          final prefs = await SharedPreferences.getInstance();
                          bool marketingConsent = prefs.getBool('marketingConsent') ?? false;
                          await usersService.setMarketingConsent(userId, marketingConsent);
                          Navigator.popAndPushNamed(context, "/main");
                          user.setLogin(true);
                          _firebaseMessaging.getToken().then((String? token) async {
                            assert(token != null);
                            await usersService.setFCM(UserSaveReq(fcmToken: token));
                            print("FCM Token: $token");
                            // 이 토큰을 Spring Boot 서버에 전송하여 저장
                          });
                        }


                      } catch (error) {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                title: Text("에러 발생"),
                                content: Text(error.toString()),
                              );
                            });
                      }
                    })
              ],
            )
            ),
          ),
        ),
      ),
    );
  }

  // Widget _agreement(){

  // }

}
