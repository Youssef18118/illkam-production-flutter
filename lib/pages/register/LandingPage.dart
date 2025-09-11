import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/apis/usersAPI.dart';
import 'package:ilkkam/models/req/UsersLoginReq.dart';
import 'package:ilkkam/models/req/UsersSaveReq.dart';
import 'package:ilkkam/pages/consent/ConsentPage.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  static const routeName = "/LandingPage";

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  final UsersService usersService= UsersService();
  final BaseAPI baseAPI = BaseAPI();
  TextEditingController emailC = TextEditingController();
  TextEditingController passswordC = TextEditingController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    baseAPI.getJWT().then((value){
      if(value != null){
        Provider.of<UserController>(context,listen: false).setLogin(true);
      }
    });

    // usersService.getUserData();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60,),

                Center(
                  child: Image.asset("assets/splash_icon.png"),
                ),
                SizedBox(height: 100,),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IkTextField(
                        placeholder: "example@naver.com",
                        label: "이메일",
                        controller: emailC,
                        // formatters: [NameFormatter()],
                      ),
                      SizedBox(height: 20,),
                      IkTextField(
                        keyboardType: TextInputType.visiblePassword,
                        placeholder: "비밀번호를 입력해주세요.",
                        label: "비밀번호",
                        controller: passswordC,
                        // formatters: [NameFormatter()],
                      ),
                      SizedBox(height: 100,),
                      IKCommonBtn(title: "로그인", onTap: ()async {
                        await usersService.login(UserLoginReq(
                          email: emailC.text,
                          password: passswordC.text
                        ));

                        Provider.of<UserController>(context,listen: false).setLogin(true);
                        _firebaseMessaging.getToken().then((String? token) async {
                          await usersService.setFCM(UserSaveReq(fcmToken: token));
                          print("FCM Token: $token");
                          Navigator.popAndPushNamed(context, "/main");
                          // 이 토큰을 Spring Boot 서버에 전송하여 저장
                        });

                      }),
                      SizedBox(height: 8,),
                      IKCommonBtn(title: "회원가입", onTap: (){
                        // Showing Consent Page before Showing Sign up Page
                        Navigator.pushNamed(context, ConsentPage.routeName);
                      }, type: BTN_TYPE.secondary,),
                    ],
                  ),
                )
              ],
            ),
          )
        ));
  }
}