import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/pages/chat/ChatScreenPage.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/chats/dto/Chats.dart';
import 'package:ilkkam/providers/chats/dto/UnreadRoomInfo.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/utils/ProvinceFormatter.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    Provider.of<ChatsController>(context, listen: false).initialize(context);
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chats = Provider.of<ChatsController>(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: Text(
            '채팅',
            style: TextStyle(
              color: Color(0xFF121212),
              fontSize: 19,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          )),
      body: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container(
            //   padding: EdgeInsets.all(20),
            //   child: Row(
            //     children: [
            //       TabBarItem("등록한 일깜", 0),
            //       const SizedBox(width: 4),
            //       TabBarItem("신청한 일깜", 1),
            //     ],
            //   ),
            // ),
            // const IKDiver(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: TabBar(
                  controller: tabController,
                  indicatorColor:  Color(0xFF41474A),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(
                    color: Color(0xFF41474A),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: Color(0xFFADADAD),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                  dividerColor: Color(0xFFE0E0E0),
                  tabs: [
                    Tab(
                      text: "내가 등록한",
                    ),
                    Tab(
                      text: "내가 신청한",
                    )
                  ]),
            ),
            Expanded(
              child: Consumer<ChatsController>(builder: (context,chats,child){
                return TabBarView(controller: tabController, children: [
                  _chatLists(
                      chats.requestChats, false, chats.isChatLoading, context),
                  _chatLists(chats.applyChats, true, chats.isChatLoading, context)
                ]);
              })
            )
          ],
        ),
      ),
    );
  }

  Widget _chatLists(List<Chats> chats, bool isApply, bool isChatLoading,
      BuildContext context) {
    final unreadC = Provider.of<ChatsController>(context);

    return Container(
      padding: EdgeInsets.all(20),
      child: isChatLoading
          ? Column(children: [
            SizedBox(
              height: 50,width:50,child: RefreshProgressIndicator(),
            )
      ],)
          : ListView.separated(
              shrinkWrap: true,
              itemBuilder: (BuildContext ctx, int index) {
                if (index == chats.length) {
                  return SizedBox(
                    height: 60,
                  );
                }
                Chats chat = chats[index];
                // Users user = !isApply ? chat.employee! : chat.employer!;
                String? profileImg =
                    !isApply ? chat.employeeProfile : chat.employerProfile;
                String? name = !isApply ? chat.employeeName : chat.employerName;
                UnreadRoomInfo unread = unreadC.unreadRoomInfo.firstWhere(
                    (elem) => elem.roomId == chat.id,
                    orElse: () => UnreadRoomInfo());
                return Slidable(
                    key: Key((chat.id ?? -1).toString()),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          autoClose: true,
                          onPressed: (context) async {
                            await Provider.of<ChatsController>(context,
                                    listen: false)
                                .exitChat(chat.id ?? '', context);
                          },
                          backgroundColor: Color(0xFF5CD1F4),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        print("대화 신청 눌림 ");
                        await Provider.of<ChatsController>(context,
                                listen: false)
                            .prepareOpenChat(
                                chat.id ?? "",
                                Provider.of<UserController>(context,
                                        listen: false)
                                    .id);
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(ChatScreen.routeName);
                      },
                      child: Container(
                        // height: 48,
                        padding: const EdgeInsets.only(right: 5),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: profileImg != null
                                  ? Image.network(
                                      profileImg,
                                      fit: BoxFit.fill,
                                      width: 48,
                                      height: 48,
                                    )
                                  : SvgPicture.asset("assets/main/user_ico.svg",
                                      fit: BoxFit.fill, width: 48, height: 48),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFFE2E6E7),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                                ),
                                                child: Text(
                                                    formatProvince(chat.workLocation?? '')
                                                )
                                            ),
                                            SizedBox(width: 4,),
                                            Text(
                                              name ?? '',
                                              style: TextStyle(
                                                color: Color(0xFF191919),
                                                fontSize: 16,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (unread.unreadCount != null &&
                                            unread.unreadCount! > 0)
                                          Container(
                                            width: 16,
                                            height: 16,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF01A9DB)),
                                            child: Text(
                                              unread.unreadCount.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          DateFormat("MM월 dd일").format(
                                              DateTime.parse(chat.workDate ??
                                                  '2024-10-19')),
                                          style: TextStyle(
                                            color: Color(0xFF7D7D7D),
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          width: 3,
                                          height: 3,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: ShapeDecoration(
                                            color: Color(0xFFC7C7C7),
                                            shape: OvalBorder(),
                                          ),
                                        ),
                                        SizedBox(
                                          // width: MediaQuery.of(context).size.width - 109,
                                          child: Text(
                                            chat.workType ?? '',
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Color(0xFF7D7D7D),
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Container(
                                          width: 3,
                                          height: 3,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: ShapeDecoration(
                                            color: Color(0xFFC7C7C7),
                                            shape: OvalBorder(),
                                          ),
                                        ),
                                        SizedBox(
                                          // width: MediaQuery.of(context).size.width - 109,
                                          child: Text(
                                            NumberFormat('#,###')
                                                    .format(chat.price) +
                                                '원',
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Color(0xFF7D7D7D),
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w500,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          unread.lastChat != null
                                              ? replaceImageMessage(
                                                  unread.lastChat!)
                                              : replaceImageMessage(
                                                  chat.lastChatMsg ??
                                                      '채팅 내역 없음'),
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                        Text(
                                          unread.lastChat != null
                                              ? lastChatTimeFormatter(
                                                  unread.lastChatTime ?? '')
                                              : lastChatTimeFormatter(
                                                  chat.lastChatTime ??
                                                      '채팅 내역 없음'),
                                          style: TextStyle(
                                            color: Color(0xFF7D7D7D),
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
              },
              separatorBuilder: (ctx, index) {
                return Divider(
                  color: AppColors.dividerColor,
                  height: 40,
                );
              },
              itemCount: chats.length + 1),
    );
  }

  String lastChatTimeFormatter(String? lastChatTime) {
    print("lastChatTime is $lastChatTime");
    if (lastChatTime == null || lastChatTime == '') {
      return '';
    }
    DateTime now = DateTime.now();
    if(lastChatTime == "채팅 내역 없음"){
      return '';
    }
    DateTime time = DateTime.parse(lastChatTime);
        // .add(Duration(hours: 9));
    if (time.day == now.day && time.month == now.month) {
      return DateFormat("a hh:mm", "ko").format(time);
    } else {
      return DateFormat("MM월 dd일").format(time);
    }
  }

  Widget TabBarItem(String label, int index) {
    bool selected = index == tabController.index;
    return GestureDetector(
      onTap: () {
        tabController.index = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: selected ? Color(0xFF01A9DB) : Colors.white,
          shape: RoundedRectangleBorder(
            side: !selected
                ? BorderSide(width: 1, color: Color(0xFFE1E1E1))
                : BorderSide(width: 1, color: Color(0xFF01A9DB)),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Color(0xFFADADAD),
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String replaceImageMessage(String message) {
    if (message.startsWith("base64/image:")) {
      return "사진";
    } else {
      return message;
    }
  }
}
