import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';
import 'package:ilkkam/pages/main/UploadWorkPage.dart';
import 'package:ilkkam/pages/main/WorkListPage.dart';
import 'package:ilkkam/pages/main/widgets/IKCategoryLists.dart';
import 'package:ilkkam/pages/main/widgets/WorkDayCountWidget.dart';
import 'package:ilkkam/pages/main/widgets/WorkFilters.dart';
import 'package:ilkkam/pages/register/LandingPage.dart' as register;
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/WorkRepository.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKBlankDivider.dart';
import 'package:ilkkam/widgets/WorkItem.dart';
import 'package:provider/provider.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  WorkRepository workRepository = WorkRepository();
  BaseAPI baseAPI = BaseAPI();
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  List<WorkInfoDetail> workInfoDetails = [];

  @override
  void initState() {
    Provider.of<WorkController>(context, listen: false).initializeFilters();
    baseAPI.getJWT().then((v) =>
        Provider.of<UserController>(context, listen: false).setUserId(v));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final work = Provider.of<WorkController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: RefreshIndicator(
                key: _refreshKey,
                onRefresh: () async {
                  work.selectedProvince = null;
                  work.selectedWorkDetailType = null;
                  work.selectedWorkType = null;
                  await work.reload();
                },
                child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (ScrollUpdateNotification notification) {
                      work.listner(notification);
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: work.landingPageScrollC,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          IkCategoryLists(),
                          IKBlankDivider(
                            margin: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 0, bottom: 20),
                            child: Column(children: [
                              WorkFilters(
                                isLandingPage: true,
                              ),
                              WorkDayCountWidget(
                                isLandingPage: true,
                              ),
                            ]),
                          ),

                          IKBlankDivider(
                            margin: 0,
                          ),
                          // 아래쪽 최근 등록된 일깜
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(children: [
                                        const TextSpan(
                                          text: '최근 등록된  ',
                                          style: TextStyle(
                                            color: Color(0xFF121212),
                                            fontSize: 19,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                            text: '일깜',
                                            style: IKTextStyle.appMainText),
                                      ]),
                                    ),
                                    MaterialButton(
                                      minWidth: 0,
                                      visualDensity: VisualDensity.compact,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      onPressed: () {
                                        Provider.of<WorkController>(context,
                                                listen: false)
                                            .changeMonth(DateTime.now(),
                                                fromDayCount: true);
                                        Navigator.of(context)
                                            .pushNamed(WorkListPage.routeName);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "더보기",
                                            style: TextStyle(
                                              color: const Color(0xFF7D7D7D),
                                              fontSize: 14,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(Icons.chevron_right, )
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (BuildContext ctx, int index) {
                                return Divider(
                                  color: Color(0xFFE0E0E0),
                                  height: 30,
                                );
                              },
                              itemCount: work.recentWorks.length + 1,
                              itemBuilder: (context, index) {
                                if (index == work.recentWorks.length) {
                                  return SizedBox(
                                    height: 87,
                                  );
                                }
                                return WorkItem(
                                  work: work.recentWorks[index],
                                );
                              }),
                          // Expanded(
                          //     child: )
                        ],
                      ),
                    ))),
          ),
          Positioned(
              right: 16,
              bottom: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      work.landingPageScrollC.animateTo(0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: SvgPicture.asset("assets/main/arrow_btn_up.svg"),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  MaterialButton(
                    onPressed: () {
                      final userC = Provider.of<UserController>(context, listen: false);
                      if (!userC.login) {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(register.LandingPage.routeName);
                        return;
                      }
                      Navigator.of(context).pushNamed(UploadWorkPage.routeName);
                    },
                    elevation: 0,
                    minWidth: 0,
                    padding: const EdgeInsets.only(
                        top: 15, left: 20, right: 12, bottom: 15),
                    color: const Color(0xFF01A9DB),
                    shape: RoundedRectangleBorder(
                      // side: BorderSide(width: 1, color: Color(0xFF01A9DB)),
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Container(
                      decoration: ShapeDecoration(
                        // color: Color(0xFF01A9DB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            '일깜등록',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
