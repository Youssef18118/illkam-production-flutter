import 'package:flutter/material.dart';
import 'package:ilkkam/apis/usersAPI.dart';
import 'package:ilkkam/models/req/UsersSaveReq.dart';
import 'package:ilkkam/navigations/NavigatorObserver.dart';
import 'package:ilkkam/pages/register/LandingPage.dart';
import 'package:ilkkam/pages/tabContainer.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/routes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'main.dart';


class IlkkamApp extends StatefulWidget {
  const IlkkamApp({super.key});


  @override
  State<IlkkamApp> createState() => _IlkkamAppState();
}

class _IlkkamAppState extends State<IlkkamApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  UsersService usersService = UsersService();
  bool isLogin = false;

  // @override
  // void initState() {
  //   Provider.of<UserController>(context, listen: false).initialize().then((e) {
  //     if (Provider.of<UserController>(context, listen: false).isLogIn) {
  //       // FCM 토큰 가져오기
  //       _firebaseMessaging.getToken().then((String? token) async {
  //         assert(token != null);
  //         await usersService.setFCM(UserSaveReq(fcmToken: token));
  //         print("FCM Token: $token");
  //         // 이 토큰을 Spring Boot 서버에 전송하여 저장
  //       });
  //     }
  //     setState(() {
  //       isLogin = e != null;
  //     });
  //     Provider.of<ChatsController>(context, listen: false).subscribeUnreadMessages(e ?? -1, context);
  //   });

  //   // 포그라운드에서 푸시 알림 수신 처리
  //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   //   print('Received message in foreground: ${message.notification?.title}');
  //   // });

  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState(); // It's best practice to call super.initState() first.

    // Using addPostFrameCallback ensures the context is fully mounted and ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userController = Provider.of<UserController>(context, listen: false);
      final chatsController = Provider.of<ChatsController>(context, listen: false);

      userController.initialize().then((userId) {
        // This block runs after user data is fetched.
        if (userController.isLogIn) {
          // FCM token logic for logged-in users.
          _firebaseMessaging.getToken().then((String? token) async {
            assert(token != null);
            await usersService.setFCM(UserSaveReq(fcmToken: token));
            print("FCM Token: $token");
          });
        }
        
        // This needs to be inside the .then() to ensure we have the userId.
        // It will now also call the chat data initialization internally.
        chatsController.subscribeUnreadMessages(userId ?? -1, context);

        // We use mounted check to safely call setState.
        if (mounted) {
          setState(() {
            isLogin = userController.isLogIn;
          });
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF85C06)),
        useMaterial3: true,
        fontFamily: "Pretendard",
        // primarySwatch: AppColors.primary,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 1,
          selectedIconTheme: IconThemeData(color: Colors.black),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          // TextStyle ? selectedLabelStyle,
          // TextStyle ? unselectedLabelStyle,
          type: BottomNavigationBarType.fixed,
        ));

    final tab = Provider.of<TabUIController>(context, listen: false);
    final user = Provider.of<UserController>(context, listen: false);

    return MaterialApp(
      theme: theme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ko', ''), // Korean, no country code
      ],
      home: TabContainer(),
      // initialRoute: isLogin ? TabContainer.routeName : LandingPage.routeName,
      routes: Routes.getRoutes(context),
      navigatorKey: navigatorKey,
      navigatorObservers: [
        MyNavigatorObserver(
            onRouteChanged: (route) {
              // 경로가 변경될 때 실행할 함수
              print('Route changed to: ${route?.settings.name}');
            },
            tabUIController: tab)
      ],
      debugShowCheckedModeBanner: true,
    );
  }
}