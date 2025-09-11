import 'package:flutter/material.dart';
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

class ProfileEditPage extends StatefulWidget {
  static const routeName="/my/profile/edit";
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {

  TextEditingController nameC = TextEditingController();
  TextEditingController businessNumC = TextEditingController();
  TextEditingController businessAddC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  // 이미지 리스트
  List<String> imageURLs = [];
  UsersService usersService = UsersService();
  bool isImageUploading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserController>(context);
    return Scaffold(
      appBar: TextTitleBar(title: "프로필 수정"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // direction: Axis.vertical,
              // spacing: 20,
              children: [
                IkTextField(
                  placeholder: "전화번호를 입력해주세요.",
                  label: "전화번호",
                  controller: phoneC,
                  formatters: [PhoneNumberFormatter()],
                ),
                SizedBox(
                  height: 20,
                ),
                IkTextField(
                  placeholder: "이메일을 입력해주세요.",
                  label: "이메일 주소",
                  controller: emailC,
                  formatters: [EmailFormatter()],
                ),
                SizedBox(
                  height: 20,
                ),
                IkTextField(
                  placeholder: "사업자 주소를 입력해주세요.",
                  label: "사업자 주소",
                  controller: businessAddC,
                ),
                // SizedBox(height: 20,),
                // _companyPicture(),

                SizedBox(
                  height: 60,
                ),
                IKCommonBtn(
                    title: "수정하기",
                    onTap: () async {
                      try {
                        String bus = businessAddC.value.text;
                        String email = emailC.value.text;
                        String phone = phoneC.value.text;
                        UserSaveReq req = UserSaveReq(
                            businessAddress:bus == "" ?  user.me?.businessAddress : bus,
                            email:email == ""?user.me?.email : email ,
                            phoneNumber: phone == ""? user.me?.phoneNumber : phone,
                        );
                        await usersService.edit(req);
                        Navigator.pop(context);

                        Provider.of<UserController>(context, listen: false)
                            .setLogin(true);
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
            ),
          ),
        ),
      ),
    );
  }
}
