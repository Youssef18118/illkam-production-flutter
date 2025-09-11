import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ilkkam/app.dart';
import 'package:ilkkam/firebase_options.dart';
import 'package:ilkkam/pages/community/CommuDetailPage.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:ilkkam/providers/applies/AppliesController.dart';
import 'package:ilkkam/providers/chats/ChatsRepository.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/posts/PostsController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


import 'pages/chat/ChatScreenPage.dart';
import 'pages/main/WorkDetailpage.dart';
import 'dart:io';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 백그라운드 설정 코드는 맨 최상단에 위치해야함
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await fcmSetting();
  await setupInteractedMessage();

  final int? jwt = await UserController(false).initialize();
  bool isLogin = jwt != null;
  // FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

  final res = await ChatsRepository().getUnreadRoomInfo(userid: jwt ?? -1);

  runApp(MultiProvider(providers: [
    // ChangeNotifierProvider<ChatsController>(create: (context) => ChatsController(res)),
    ChangeNotifierProvider<PostsController>(
      create: (context) => PostsController(),
    ),
    ChangeNotifierProvider<TabUIController>(
      create: (context) => TabUIController(),
    ),
    ChangeNotifierProvider<UserController>(
      create: (context) => UserController(isLogin),
    ),
    ChangeNotifierProvider<ChatsController>(
      create: (context) => ChatsController(res),
    ),
    ChangeNotifierProvider<WorkController>(
      create: (context) => WorkController(),
    ),
    ChangeNotifierProvider<AppliesController>(
      create: (context) => AppliesController(),
    ),
  ], child: IlkkamApp()));
}

Future<void> fcmSetting() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true);

  var initialzationSettingsIOS = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initialzationSettingsIOS);
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.getActiveNotifications();

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // 예외 처리: iOS는 시스템에서 이미 알림 표시하므로 로컬 알림 띄우지 않음
    if (Platform.isIOS) return;

    // 채팅 화면 예외 처리
    final isChatScreenOpen = Provider.of<ChatsController>(
      navigatorKey.currentContext!,
      listen: false,
    ).isChatScreenOpen;

    if (isChatScreenOpen && (message.data['routeName'] ?? '') == "chats") {
      return;
    }

    if (notification != null || message.data.isNotEmpty) {
      flutterLocalNotificationsPlugin.show(
        notification?.hashCode ?? 0,
        notification?.title ?? message.data['title'],
        notification?.body ?? message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

// 토큰 발급
//   var fcmToken = await FirebaseMessaging.instance.getToken();

// 토큰 리프레시 수신
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    // save token to server
  });
}

Future<void> setupInteractedMessage() async {
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    await handleFCMClick(initialMessage);
  }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    await handleFCMClick(message);
  });
}

Future<void> handleFCMClick(RemoteMessage message) async {
  final context = navigatorKey.currentContext;
  if (context == null) return;
  final chatsController = Provider.of<ChatsController>(context, listen: false);
  final postsController = Provider.of<PostsController>(context, listen: false);
  final workController = Provider.of<WorkController>(context, listen: false);

  String targetPageId = message.data['targetPageId'];
  final routeName = message.data['routeName'];

  if (chatsController.isChatScreenOpen && routeName == "chats") {
    return;
  }

  switch (routeName) {
    case "work":
      workController.selectedWork = Work(id: int.parse(targetPageId));
      navigatorKey.currentState?.pushNamed(WorkDetailPage.routeName);
      break;
    case "chat":
      chatsController.getChatInfo(targetPageId);
      navigatorKey.currentState?.pushNamed(ChatScreen.routeName);
      break;
    case "post":
      postsController.refreshSelectedPosts(int.parse(targetPageId));
      navigatorKey.currentState?.pushNamed(CommuDetailPage.routeName);
      break;
  }
}
