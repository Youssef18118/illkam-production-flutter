import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/pages/CommonUserPage.dart';
import 'package:ilkkam/pages/community/CommuWritePage.dart';
import 'package:ilkkam/pages/community/widgets/ArticleLabel.dart';
import 'package:ilkkam/pages/community/widgets/CommuDeleteDialog.dart';
import 'package:ilkkam/providers/posts/PostsController.dart';
import 'package:ilkkam/pages/community/widgets/ReplyWriter.dart';
import 'package:ilkkam/providers/posts/Posts.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKImageList.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommuDetailPage extends StatefulWidget {
  const CommuDetailPage({super.key});

  static const routeName = "/CommuDetailPage";

  @override
  State<CommuDetailPage> createState() => _CommuDetailPageState();
}

class _CommuDetailPageState extends State<CommuDetailPage> {
  final TextEditingController _commentC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Posts? post = Provider.of<PostsController>(context).selectedPosts;
    Users? user = Provider.of<UserController>(context).me;
    if (post == null) {
      return Center(
        child: RefreshProgressIndicator(),
      );
    }



    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post.category != null)
                        ArticleLabel(dto: post.category!),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [if (post.writer != null) _writerInfo(post.writer, post),
                          if (post.writer?.id == user?.id) moreButton(post)],
                      )
                    ],
                  ),
                  const Divider(
                    color: Colors.transparent,
                    height: 20,
                  ),
                  Text(
                    post.title ?? '',
                    style: const TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 17,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      post.contents ?? '',
                      style: const TextStyle(
                        color: Color(0xFF494949),
                        fontSize: 15,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (post.images?.isNotEmpty ?? false)
                    IKImageList(label: "첨부 사진", images: post.images ?? []),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(color: Color(0xFFFAFAFA)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        '댓글 ',
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 17,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${post?.replies?.length}",
                        style:  TextStyle(
                          color: Color(0xFF0098C5),
                          fontSize: 17,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,

                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _replies(post.replies ?? []),
                  const SizedBox(
                    height: 66,
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(bottom: 0, child: ReplyWriter())
      ],
    );
  }

  Widget _writerInfo(Users? writer, Posts? post) => GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(CommonUserPage.routeName, arguments: writer?.id ?? -1);
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.network(writer?.businessCertification ?? '', width: 60,height: 60,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: 16,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        writer?.name ?? '',
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 15,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat("yyyy-MM-dd 작성됨").format(DateTime.parse(post?.createdDateTime ?? "2025-01-01")) ?? '',
                        style: TextStyle(
                          color: Color(0xFFA6AEB1),
                          fontSize: 13,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.69,
                        ),
                      ),

                    ],
                  )

                ],
              )
            ],
          ),
        ),
      );

  Widget _replies(List<Replies> replies) => ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext ctx, int index) {
        Replies reply = replies[index];
        return _reply_item(reply);
      },
      separatorBuilder: (BuildContext ctx, int index) {
        return Divider(
          color: AppColors.dividerColor,
          height: 40,
        );
      },
      itemCount: replies.length);

  Widget _reply_item(Replies reply) => GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(CommonUserPage.routeName,
              arguments: reply.writer?.id ?? -1);
        },
        child: Container(
          child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: reply.writer?.businessCertification != null
                            ? Image.network(
                          reply.writer!.businessCertification!,
                          fit: BoxFit.fill,
                          width: 32,
                          height: 32,
                        )
                            : SvgPicture.asset("assets/main/user_ico.svg",
                            fit: BoxFit.fill, width: 32, height: 32),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              reply.writer?.name ?? '',
                              style: TextStyle(
                                color: Color(0xFF191919),
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Text(
                            //   DateFormat("yyyy-MM-dd").format(DateTime.parse(reply.writer?.createdDateTime ?? "2025-01-01")) ?? '',
                            //   style: TextStyle(
                            //     color: Color(0xFFA6AEB1),
                            //     fontSize: 13,
                            //     fontFamily: 'Pretendard',
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),

                    child: Text(
                      reply.contents ?? '',
                      style: TextStyle(
                        color: Color(0xFF494949),
                        fontSize: 15,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )

        ),
      );

  Widget moreButton(Posts? post) {
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
          _menuItem("수정하기", post!),
          _menuItem("삭제하기", post!),
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

  PopupMenuItem<String> _menuItem(String text, Posts post) {
    return PopupMenuItem<String>(
      enabled: true,
      onTap: () {
        if (text == "수정하기") {
          Navigator.of(context).pushNamed(CommuWritePage.routeName,
              arguments: {"edit": true, "post": post});
        } else {
          print(post.toJson());
          showCommuDeleteConfirmDialog(context, post.id ?? -1);
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
