import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/pages/main/UploadWorkPage.dart';
import 'package:ilkkam/pages/main/widgets/WorkDayCountWidget.dart';
import 'package:ilkkam/pages/main/widgets/WorkFilterMonth.dart';
import 'package:ilkkam/pages/main/widgets/WorkFilters.dart';
import 'package:ilkkam/pages/register/LandingPage.dart' as register;
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/dto/WorksSummaryDto.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKDivider.dart';
import 'package:ilkkam/widgets/WorkItem.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkListPage extends StatefulWidget {
  const WorkListPage({super.key});

  static const routeName = "/work-list-page";

  @override
  State<WorkListPage> createState() => _WorkListPageState();
}

class _WorkListPageState extends State<WorkListPage> {
  // Create a local ScrollController for this page
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
    // TODO: implement initState
    super.initState();
  }
  
  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    DateTime dateTime =
        Provider.of<WorkController>(context, listen: false).selectedDate;
    // 각 날짜 항목의 너비 (여기서는 임의로 80을 사용)
    double itemWidth = 58.0;

    int idx = Provider.of<WorkController>(context, listen: false)
        .workListWorkSummary
        .indexWhere((WorksSummaryDto dto) {
      return dto.date == DateFormat("yyyy-MM-dd").format(dateTime);
    });
    // 선택된 날짜가 화면 중앙에 오도록 스크롤 위치 계산
    double targetScrollOffset = (idx * itemWidth) -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);

    // ScrollController의 jumpTo를 사용하여 위치 설정
    Provider.of<WorkController>(context, listen: false)
        .dayListWidgetScrollController
        ?.jumpTo(targetScrollOffset);
  }

  @override
  Widget build(BuildContext context) {
    final workC = Provider.of<WorkController>(context);
    return RefreshIndicator(
        onRefresh: () async {
          workC.selectedProvince = null;
          workC.selectedWorkDetailType = null;
          workC.selectedWorkType = null;
          await workC.reloadWorkListPage();
        },
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 8, bottom: 00, left: 20, right: 20),
                child: NotificationListener<ScrollUpdateNotification>(
                  onNotification: (ScrollUpdateNotification notification) {
                    workC.listner(notification);
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        title(),

                        const WorkFilters(
                          isLandingPage: false,
                        ),
                        Row(children: [
                          SizedBox(width: 120,
                            child: const WorkFilterMonth(),
                          )
                        ],)
                        ,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: WorkDayCountWidget(
                            isLandingPage: false,
                          ),
                        ),

                        const IKDiver(),
                        const SizedBox(
                          height: 20,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 500), // 최소 높이 200
                          child: ListView.separated(

                            physics: NeverScrollableScrollPhysics(),
                            itemCount: workC.workListWorks.length +
                                (workC.hasMore ? 1 : 0),
                            shrinkWrap: true,
                            separatorBuilder: (BuildContext ctx, int index) {
                              return const Divider(
                                color: Color(0xFFE0E0E0),
                                height: 40,
                              );
                            },
                            itemBuilder: (context, int index) {
                              if (index == workC.workListWorks.length) {
                                // 로딩 인디케이터
                                return Center(child: CircularProgressIndicator());
                              }
                              return WorkItem(
                                work: workC.workListWorks[index],
                              );
                            }),),
                        if (workC.isLoading)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                )),
            Positioned(
                right: 16,
                top: MediaQuery.of(context).size.height-280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                   GestureDetector(
                      onTap: (){
                        _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                      },
                      child: SvgPicture.asset("assets/main/arrow_btn_up.svg"),
                    ),
                    SizedBox(height: 12,),
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
                )),
          ],
        )

        );
  }

  Widget title() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Text(
                  '모집중 ',
                  style: TextStyle(
                    color: Color(0xFF121212),
                    fontSize: 19,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 5),
                Text('일깜', style: IKTextStyle.appMainText),
              ],
            ),
          ),

        ],
      );
}
