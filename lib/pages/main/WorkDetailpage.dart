import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';
import 'package:ilkkam/pages/chat/ChatScreenPage.dart';
import 'package:ilkkam/pages/main/EditWorkPage.dart';
import 'package:ilkkam/pages/main/EmployerDetailPage.dart';
import 'package:ilkkam/pages/main/widgets/WorkDeleteDialog.dart';
import 'package:ilkkam/providers/applies/AppliesRepository.dart';
import 'package:ilkkam/providers/applies/dto/Apply.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/WorkRepository.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/utils/imagePicker.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKCompactTextBtn.dart';
import 'package:ilkkam/widgets/IKDivider.dart';
import 'package:ilkkam/widgets/IKImageList.dart';
import 'package:ilkkam/widgets/IKTextColumn.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:ilkkam/widgets/IKTextRow.dart';
import 'package:ilkkam/widgets/IKUserItem.dart';
import 'package:ilkkam/widgets/ImagePickerWidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkDetailPage extends StatefulWidget {
  const WorkDetailPage({super.key});

  static const routeName = "/work-detail-page";

  @override
  State<WorkDetailPage> createState() => _WorkDetailPageState();
}

class _WorkDetailPageState extends State<WorkDetailPage> {
  WorkRepository workRepository = WorkRepository();
  BaseAPI baseAPI = BaseAPI();
  TextEditingController _contentsC = TextEditingController();
  int? userid;
  List<String> images = [];
  bool isImageUploading = false;

  // star rating
  double value = 3.0;

  @override
  void initState() {
    Provider.of<WorkController>(context, listen: false)
        .fetchWorkDetailInfoAndGetCanApply();
    // TODO: implement didChangeDependencies
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserController>(context);
    final work = Provider.of<WorkController>(context);

    List<Apply> applyList = work.selectedWork?.appliesList
            ?.where((elem) =>
                elem.status != APPLY_STATUS.cancel.value &&
                elem.status != APPLY_STATUS.confirm.value)
            .toList() ??
        [];
    List<Apply> confirmList = work.selectedWork?.appliesList
            ?.where((elem) => elem.status == APPLY_STATUS.confirm.value)
            .toList() ??
        [];

    bool isEmployer = work.selectedWork?.employer?.id == user.id;

    //  별점 관련
    double rating = work.selectedWork?.employer?.rating ?? 0.0;
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(color: Colors.white),
              child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('일깜', style: IKTextStyle.appMainText),
                              const SizedBox(width: 5),
                              Text(
                                '정보',
                                style: TextStyle(
                                  color: Color(0xFF121212),
                                  fontSize: 19,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          if (work.selectedWork?.employer?.id == user.id &&
                              work.selectedWork?.isConfirmed != true)
                            moreButton(work.selectedWork)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<UserController>(context, listen: false)
                                  .fetchEmployer(work.selectedWork?.employer?.id ?? -1);
                              Navigator.of(context, rootNavigator: true).pushNamed(
                                EmployerDetailPage.routeName,
                              );
                            },
                            child: Row(
                              children: [
                                ClipOval(
                                  child: work.selectedWork?.employer
                                      ?.businessCertification !=
                                      null
                                      ? Image.network(
                                    work.selectedWork!.employer!
                                        .businessCertification!,
                                    fit: BoxFit.fill,
                                    width: 54,
                                    height: 54,
                                  )
                                      : SvgPicture.asset("assets/main/user_ico.svg",
                                      fit: BoxFit.fill, width: 54, height: 54),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          work.selectedWork?.employer?.name ?? '',
                                          style: TextStyle(
                                            color: Color(0xFF191919),
                                            fontSize: 21,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        IconButton(
                                            visualDensity: VisualDensity.compact,
                                            onPressed: () {
                                              Provider.of<UserController>(context,
                                                  listen: false)
                                                  .fetchEmployer(
                                                  work.selectedWork?.employer?.id ??
                                                      -1);
                                              Navigator.of(context, rootNavigator: true)
                                                  .pushNamed(
                                                EmployerDetailPage.routeName,
                                              );
                                            },
                                            icon: Icon(Icons.chevron_right))
                                      ],
                                    ),
                                    Text(
                                      work.selectedWork?.employer?.phoneNumber ?? '',
                                      style: TextStyle(
                                        color: Color(0xFF7D7D7D),
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (work.selectedWork?.employer?.id != user.id)
                            IKCompactTextBtn(
                                label: "1:1 대화",
                                onPressed: () async {
                                  print("대화 신청 눌림 ");
                                  await Provider.of<ChatsController>(context,
                                      listen: false)
                                      .prepareOpenChatByApplier(
                                      work.selectedWork?.id ?? -1);
                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed(ChatScreen.routeName);
                                }),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 꽉 찬 별
                                    for (int i = 0; i < fullStars; i++)
                                      SvgPicture.asset(
                                        "assets/main/star.svg",
                                      ),

                                    // 반쪽 별
                                    if (hasHalfStar)
                                      SvgPicture.asset(
                                        "assets/main/star_half.svg",
                                      ),

                                    // 빈 별
                                    // for (int i = 0; i < emptyStars; i++)
                                    //   SvgPicture.asset("assets/main/star.svg",),
                                  ],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  work.selectedWork?.employer?.rating == null
                                      ? '평점 없음'
                                      : "${work.selectedWork?.employer?.rating?.toStringAsFixed(1)}",
                                  style: TextStyle(
                                    color: Color(0xFF191919),
                                    fontSize: 17,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  width: 1,
                                  height: 12,
                                  decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                                ),
                                SvgPicture.asset("assets/main/comment.svg"),
                                const SizedBox(width: 4),
                                Text(
                                  work.selectedWork?.employer?.reviewCount == null
                                      ? '0'
                                      : "${work.selectedWork?.employer?.reviewCount}",
                                  style: TextStyle(
                                    color: Color(0xFF191919),
                                    fontSize: 17,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: IKDiver(),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '상세내역',
                              style: TextStyle(
                                color: Color(0xFF191919),
                                fontSize: 17,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IKTextRow(
                                    title: "날짜", detail: work.selectedWork?.workDate),
                                Divider(color: Color(0xFFEAEAEA),height: 16,),
                                IKTextRow(
                                    title: "시간",
                                    detail: work.selectedWork?.workHour ?? "시간무관"),
                                Divider(color: Color(0xFFEAEAEA),height: 16,),
                                IKTextRow(
                                    title: "지역",
                                    detail:
                                    "${work.selectedWork?.workLocationSi} ${work.selectedWork?.workLocationGu}"),
                                if (work.selectedWork?.workTypes?.name != "견적방문 요청")
                                  Divider(color: Color(0xFFEAEAEA),height: 16,),
                                if (work.selectedWork?.workTypes?.name != "견적방문 요청")
                                  IKTextRow(
                                      title: "금액",
                                      detail: NumberFormat("#,###원")
                                          .format(work.selectedWork?.price ?? 0)),
                                Divider(color: Color(0xFFEAEAEA),height: 16,),
                                IKTextRow(
                                    title: "일깜유형",
                                    detail:
                                    "${work.selectedWork?.workTypes?.name} ${work.selectedWork?.workTypeDetails?.name != null ? "> ${work.selectedWork?.workTypeDetails?.name}" : ""}"),
                                if( work.selectedWork?.workInfoDetail?.isNotEmpty ?? false)
                                  Divider(color: Color(0xFFEAEAEA),height: 16,),
                                ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (ctx, idx) {
                                      WorkInfoDetail? info =
                                      work.selectedWork?.workInfoDetail?[idx];
                                      if (info == null) {
                                        return SizedBox.shrink();
                                      }
                                      if (info.name == "시공상세") {
                                        return
                                          Column(

                                            children: [
                                              IKTextColumn(
                                                  title: info.name ?? "",
                                                  detail: info.value.toString())
                                            ],
                                          )
                                        ;
                                      }
                                      if(info.name == "평수"){
                                        return IKTextColumn(title: info.name ?? "",
                                            detail: "${info.value}평형");
                                      }
                                      return IKTextRow(
                                          title: info.name!,
                                          detail: (info.value ?? "").toString());
                                    },
                                    separatorBuilder: (ctx, idx) => Divider(color: Color(0xFFEAEAEA),height: 16,),
                                    itemCount:
                                    work.selectedWork?.workInfoDetail?.length ?? 0),
                                Divider(color: Color(0xFFEAEAEA),height: 16,),
                                IKTextColumn(
                                  title: "요구사항",
                                  detail: work.selectedWork?.comments ?? '',
                                ),
                                // Divider(color: Color(0xFFEAEAEA),height: 16,),
                                IKImageList(
                                    label: "",
                                    images: work.selectedWork?.workImages ?? [])
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (confirmList.isNotEmpty)
                        Column(
                          children: [
                            IKDiver(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '확정업체',
                                        style: TextStyle(
                                          color: Color(0xFF191919),
                                          fontSize: 17,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        confirmList.length.toString(),
                                        style: TextStyle(
                                          color: Color(0xFF01A9DB),
                                          fontSize: 17,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // 확정자 정보
                                  if (work.selectedWork?.employee != null)
                                    Column(
                                      children: [
                                        IKUserItem(
                                          user: work.selectedWork!.employee!,
                                          apply: work.selectedWork?.appliesList
                                              ?.firstWhere((elem) =>
                                          elem?.applier?.name ==
                                              work?.selectedWork?.employee
                                                  ?.name) ??
                                              Apply(),
                                          showReviewBtn: isEmployer,
                                          isReviewPosted:
                                          work.selectedWork?.didEmployeeReviewed ??
                                              false,
                                          writeReview: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    StatefulBuilder(builder:
                                                        (BuildContext context,
                                                        StateSetter setDialog) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "리뷰 ${work.selectedWork?.didEmployeeReviewed ?? false ? "쓰기" : "수정하기"}"),
                                                        content: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            RatingStars(
                                                              value: value,
                                                              onValueChanged: (v) {
                                                                setDialog(() {
                                                                  value =
                                                                      v.floorToDouble();
                                                                });
                                                              },
                                                              starBuilder:
                                                                  (index, color) => Icon(
                                                                Icons.star,
                                                                color: color,
                                                              ),
                                                              starCount: 5,
                                                              starSize: 20,
                                                              valueLabelColor:
                                                              const Color(0xff9b9b9b),
                                                              valueLabelTextStyle:
                                                              const TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                  fontSize: 12.0),
                                                              valueLabelRadius: 10,
                                                              maxValue: 5,
                                                              starSpacing: 2,
                                                              maxValueVisibility: true,
                                                              valueLabelVisibility: true,
                                                              // animationDuration:
                                                              //     Duration(milliseconds: 1000),
                                                              valueLabelPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 1,
                                                                  horizontal: 8),
                                                              valueLabelMargin:
                                                              const EdgeInsets.only(
                                                                  right: 8),
                                                              starOffColor:
                                                              const Color(0xffe7e8ea),
                                                              starColor: Colors.yellow,
                                                            ),
                                                            SizedBox(
                                                              height: 12,
                                                            ),
                                                            IkTextField(
                                                              placeholder: "내용 입력",
                                                              label: "내용 입력 (필수)",
                                                              maxline: 5,
                                                              controller: _contentsC,
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                        actions: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                  child: IKCommonBtn(
                                                                    title: "취소",
                                                                    onTap: () {
                                                                      Navigator.of(context)
                                                                          .pop();
                                                                    },
                                                                    type: BTN_TYPE.secondary,
                                                                  )),
                                                              SizedBox(
                                                                width: 12,
                                                              ),
                                                              Expanded(
                                                                  child: IKCommonBtn(
                                                                      title: "등록",
                                                                      onTap: () async {
                                                                        await work.reviewWork(
                                                                            _contentsC
                                                                                .text,
                                                                            value.toInt(),
                                                                            images.isNotEmpty
                                                                                ? images[
                                                                            0]
                                                                                : null,
                                                                            work.selectedWork
                                                                                ?.id ??
                                                                                -1,
                                                                            work
                                                                                .selectedWork
                                                                                ?.employee
                                                                                ?.id ??
                                                                                -1);
                                                                        _contentsC
                                                                            .clear();
                                                                        images = [];
                                                                        Navigator.of(
                                                                            context)
                                                                            .pop();
                                                                      }))
                                                            ],
                                                          )
                                                        ],
                                                      );
                                                    }));
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            )
                            // confirmedUsers(
                            //     confirmList, work.selectedWork, isEmployer, () {
                            //
                            // })
                          ],
                        ),
                      IKDiver(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '신청자 정보',
                                  style: TextStyle(
                                    color: Color(0xFF191919),
                                    fontSize: 17,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  applyList.length.toString(),
                                  style: TextStyle(
                                    color: Color(0xFF01A9DB),
                                    fontSize: 17,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // 신청자 정보
                            SizedBox(height: 102,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  // physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder: (BuildContext ctx, int index) {
                                    return SizedBox(
                                      height: 20,
                                    );
                                  },
                                  shrinkWrap: true,
                                  itemCount: applyList.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    Apply? apply = applyList[index];
                                    Users user = apply.applier ?? Users();
                                    return IKUserItem(
                                      user: user,
                                      apply: apply,
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),

                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),





          ),
        ),
        if (work.canApply)
          Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: IKCommonBtn(
                            title: "신청하기",
                            onTap: () async {
                              await workRepository.applyWork(
                                  1, work.selectedWork?.id ?? -1);
                              work.reload();
                              Navigator.of(context).pop();
                            }),),
                    ],
                  ),
                ),
              ],
            ),
          ),

      ],
    )
      ;
  }

  Widget confirmedUsers(List<Apply> applies, Work? work, bool isEmployer,
      void Function()? writeReview) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '확정업체',
                style: TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                applies.length.toString(),
                style: TextStyle(
                  color: Color(0xFF01A9DB),
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext ctx, int index) {
                return SizedBox(
                  height: 20,
                );
              },
              shrinkWrap: true,
              itemCount: applies.length,
              itemBuilder: (BuildContext ctx, int index) {
                Apply apply = applies[index];
                Users user = applies[index].applier ?? Users();

                return Column(
                  children: [
                    IKUserItem(
                      user: user,
                      apply: apply,
                      showReviewBtn: isEmployer,
                      writeReview: writeReview,
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }

  Widget moreButton(Work? selectedWork) {
    return PopupMenuButton<String>(
      /// 팝업 메뉴의 테두리와 round 처리
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Colors.black12),
        borderRadius: BorderRadius.circular(7),
      ),

      /// 팝업메뉴 펼쳐졌을 때 그림자 컬러
      shadowColor: Colors.black26,

      /// z축 높이
      elevation: 30,

      /// 팝업메뉴의 배경 컬러
      /// icon이나 child 위젯을 선택하지 않을 때 나오는 기본 아이콘의 컬러
      color: Colors.white,
      tooltip: "",

      /// 팝업메뉴가 펼쳐질 때 위치설정
      /// over = 아이콘 위로 펼쳐짐
      /// under = 아이콘 아래에서 펼쳐짐
      position: PopupMenuPosition.under,

      /// 펼쳤을 때 나오는 항목들 List<PopupMenuItem>
      itemBuilder: (context) {
        return [
          _menuItem("수정하기", selectedWork!),
          _menuItem("삭제하기", selectedWork!),
        ];
      },

      /// 메뉴 아이템이 펼쳐졌을 때 호출
      onOpened: () {},

      /// 펼쳐진 항목 선택하지 않고, 배경 터치해서 취소한 경우
      onCanceled: () {},

      /// 선택한 값이 들어옴
      onSelected: (value) {},

      /// 펼쳐진 팝업메뉴의 사이즈 제한
      constraints: const BoxConstraints(minWidth: 30, maxWidth: 150),

      /// 메뉴아이템이 펼쳐지는 위치 변경
      /// Offset(20,20)이면 x축 오른쪽으로 20, y축 아래로 20 이동
      offset: const Offset(20, 20),

      /// child와 icon은 둘 중 한개만 사용 가능
      /// 둘 다 입력 안하면 기본 아이콘 출력
      // child: const Text("팝업메뉴 호출" ,style: TextStyle(fontSize: 30),),
      icon: const Icon(
        Icons.more_vert,
      ),

      /// 아이콘 클릭했을 때 나오는 splash 물결 사이즈
      splashRadius: 16,

      /// 아이콘 사이즈
      iconSize: 24,

      /// padding은 아이콘 argument를 사용할 때만 적용
      /// child에는 적용 안됨

      /// true = 팝업메뉴 호출 가능
      /// false = 팝업메뉴 호출 불가능
      enabled: true,

      /// true = 클릭 사운드 on
      /// false = 클릭 사운드 off
      enableFeedback: true,
    );
  }

  PopupMenuItem<String> _menuItem(String text, Work work) {
    return PopupMenuItem<String>(
      enabled: true,
      onTap: () {
        if (text == "수정하기") {
          Navigator.of(context).pushNamed(EditWorkPage.routeName,
              arguments: {"edit": true, "work": work});
        } else {
          print(work.toJson());
          showWorkDeleteConfirmDialog(context, work.id ?? -1);
        }
      },

      /// value = value에 입력한 값이 PopupMenuButton의 initialValue와 같다면
      /// 해당 아이템 선택된 UI 효과 나타남
      /// 만약 원하지 않는다면 Theme 에서 highlightColor: Colors.transparent 설정
      value: text,
      height: 40,
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
