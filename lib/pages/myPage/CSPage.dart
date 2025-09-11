import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CsPage extends StatefulWidget {
  static const routeName="/common-cs-page";
  const CsPage({super.key});

  @override
  State<CsPage> createState() => _CsPageState();
}

class _CsPageState extends State<CsPage> {

  String _appVersion = "Loading...";

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = "${packageInfo.version}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color(0xFFF4F4F4),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text(
              '고객센터',
              style: TextStyle(
                color: const Color(0xFF63696C),
                fontSize: 15,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,

                letterSpacing: -0.15,
              ),
            )),
        body: Container(

          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                        '버전 정보',
                        style: TextStyle(
                          color: const Color(0xFF191919),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                    Text(
                        'v${_appVersion}',
                        style: TextStyle(
                          color: const Color(0xFF848A8D),
                          fontSize: 13,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.69,
                        ),
                      ),

                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      '봉구와 갈치',
                      style: TextStyle(
                        color: const Color(0xFF242B2E),
                        fontSize: 17,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.17,
                      ),
                    ),
                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Row(

                          spacing: 8,
                          children: [
                            Text(
                              '사업자명',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF848A8D),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '봉구와갈치',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF63696C),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              '사업자등록번호',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF848A8D),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '205-30-52454',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF63696C),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              '이메일주소',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF848A8D),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'jjangman30@naver.com',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFF63696C),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )

            ],
          ),
        ));
  }
}
