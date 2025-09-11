import 'package:flutter/material.dart';
import 'package:ilkkam/pages/chat/ChatScreenPage.dart';
import 'package:ilkkam/pages/main/WorkDetailpage.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/fcm/FCMRepository.dart';
import 'package:ilkkam/providers/fcm/dto/Notifications.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});

  static const routeName = "/notification-list-page";

  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final FCMRepository fcmRepository = FCMRepository();
  List<Notifications> noties = [];

  @override
  void initState() {
    fcmRepository.getAllNotifications().then((v) => setState(() {
      noties = v;
    }));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              Notifications notifications = noties[index];
              return GestureDetector(
                onTap: (){
                  switch(notifications.routeName){
                    case 'work':
                      Provider.of<WorkController>(context,listen: false).selectedWork = Work(id: int.parse(notifications.targetPageId!));
                      Navigator.of(context).pushNamed(WorkDetailPage.routeName);
                      break;
                    case 'chat':
                      Provider.of<ChatsController>(context,listen: false).getChatInfo(notifications.targetPageId!);
                      Navigator.of(context).pushNamed(ChatScreen.routeName);
                      break;
                  }
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${notifications.title}" ??
                                      '',
                                  // '인천시 서구 가정동',,
                                  style: const TextStyle(
                                    color: Color(0xFF494949),

                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  DateFormat("MM.dd (E)", "ko").format(DateTime.parse(notifications.createdDateTime ?? '2024-10-05').add(Duration(hours: 9))),
                                  style: TextStyle(
                                    color: Color(0xFF747474),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${notifications.body}',
                              style: TextStyle(
                                color: Color(0xFF191919),
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, idx) => Divider(),
            itemCount: noties.length),
      ),
    );
  }
}
