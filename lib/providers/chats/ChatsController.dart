import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ilkkam/providers/chats/ChatsRepository.dart';
import 'package:ilkkam/providers/chats/dto/ChatMessage.dart';
import 'package:ilkkam/providers/chats/dto/Chats.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../apis/base.dart';
import 'dto/UnreadRoomInfo.dart';

class ChatsController with ChangeNotifier {
  List<Chats> applyChats = [];
  List<Chats> requestChats = [];
  List<ChatMessage> roomMessages = [];

  String? _currentRoomId;

  String? get currentRoomId => _currentRoomId;

  void enterRoom(String roomId) {
    _currentRoomId = roomId;
    notifyListeners();
  }

  void exitRoom() {
    _currentRoomId = null;
    notifyListeners();
  }

  bool _isChatScreenOpen = false;

  bool get isChatScreenOpen => _isChatScreenOpen;

  void openChatScreen() {
    _isChatScreenOpen = true;
    notifyListeners();
  }

  void closeChatScreen() {
    _isChatScreenOpen = false;
    notifyListeners();
  }

  Chats? selectedChats;
  String? selectedChatsOpName;
  String? selectedChatsOpPhoto;
  int? selectedChatsOpId;

  bool isChatLoading = false;
  final ChatsRepository chatsRepository = ChatsRepository();

  ChatsController(List<UnreadRoomInfo> initRoomINfo) {
    unreadRoomInfo = initRoomINfo;
    int count = 0;
    unreadRoomInfo.forEach((elem) {
      count = count + elem.unreadCount!;
    });
    unreadCount = count;
  }

  // initialize() async {
  //   isChatLoading = true;

  //   requestChats = (await chatsRepository.getRequestChat())
  //       .where((elem) => elem.employerExist ?? true)
  //       .toList();
  //   applyChats = (await chatsRepository.getApplyChats())
  //       .where((elem) => elem.employeeExist ?? true)
  //       .toList();

  //   isChatLoading = false;
  //   notifyListeners();
  // }

  Future<void> initialize(BuildContext context) async {
    final userController = Provider.of<UserController>(context, listen: false);
    if (!userController.isLogIn) {
      return;
    }

    // Prevent this method from running multiple times simultaneously
    if (isChatLoading) {
      return;
    }

    isChatLoading = true;
    // This first notifyListeners is safe if we call initialize correctly (like we just did in ChatListPage)
    // but wrapping it in a microtask makes it safe everywhere.
    Future.microtask(() => notifyListeners());

    try {
      // Use Future.wait to fetch both lists at the same time. It's faster.
      final results = await Future.wait([
        chatsRepository.getRequestChat(),
        chatsRepository.getApplyChats(),
      ]);

      requestChats = (results[0] as List<Chats>)
          .where((elem) => elem.employerExist ?? true)
          .toList();
      applyChats = (results[1] as List<Chats>)
          .where((elem) => elem.employeeExist ?? true)
          .toList();
          
    } catch (e) {
      print("Error fetching chat lists: $e");
      // Handle error case if necessary
    } finally {
      isChatLoading = false;
      notifyListeners();
    }
  }

  Future getChatRoomDetails({int page = 0}) async {
    final res = await chatsRepository.getPastMessages(selectedChats?.id ?? '',
        page: page);
    if (page == 0) {
      roomMessages = [];
      roomMessages = res;
    } else {
      roomMessages.addAll(res);
    }

    notifyListeners();
  }

  // 채팅 받았을 때
  receiveMessage(ChatMessage receive, int userid) {
    List<ChatMessage> newList = [];
    // chatsRepository.readReceivedMessage(receive.roomId ?? '', userid);
    newList.add(receive);
    newList.addAll(roomMessages);
    roomMessages = newList;
    // roomMessages.add(receive);
    rearrageChat(receive);
    sortChats();

    notifyListeners();
  }

  updateMessageAsRead(int myId) {
    print('ui 호출 진행됨');
    List<ChatMessage> newMessages = [];
    for (var elem in roomMessages) {
      if (int.parse(elem.authorId ?? "-1") != myId) {
        newMessages.add(ChatMessage(
            id: elem.id,
            roomId: elem.roomId,
            authorId: elem.authorId,
            message: elem.message,
            readCount: 2,
            createdAt: elem.createdAt));
      } else {
        newMessages.add(elem);
      }
    }
    roomMessages = newMessages;
    if (newMessages.isNotEmpty) {
      chatsRepository.readReceivedMessage(newMessages[0].roomId ?? '', myId);
    }
    notifyListeners();
  }

  // 채팅 접속한 상황에서 unread socket 제어불가하므로, 화면에서 메세지 받을 시 제어용 함수
  readAllChatsLocal(String roomId) {
    UnreadRoomInfo unreadRoom =
        unreadRoomInfo.firstWhere((elem) => elem.roomId == roomId,orElse: (){
          return UnreadRoomInfo();
        });
    unreadRoom.unreadCount = 0;
    countUnread();
  }

  getChatInfo(String chatId) async {
    selectedChats = await chatsRepository.getChat(chatId);
    notifyListeners();
  }

  makeChat(int workId) async {
    await chatsRepository.makeChat(workId);
  }

  makeRequesterChat(int workId, int applierid) async {
    await chatsRepository.makeRequesterChat(workId, applierid);
  }

  exitChat(String chatId, BuildContext context) async {
    await chatsRepository.exitChat(chatId);
    initialize(context);
  }

  setChat(Chats chat) {
    selectedChats = chat;
    notifyListeners();
  }

  prepareOpenChatByApplier(int workId) async {
    try {
      Chats? chatT = await chatsRepository.getChatApplier(workId);
      selectedChats = chatT;
    } catch (error) {
      await makeChat(workId);
      selectedChats = await chatsRepository.getChatApplier(workId);
    }
    selectedChatsOpName = selectedChats?.employerName;
    selectedChatsOpPhoto = selectedChats?.employerProfile;
    selectedChatsOpId = selectedChats?.employerId;
  }

  prepareOpenChatByRequester(int workId, int applierId) async {
    try {
      Chats? chatT = await chatsRepository.getChatRequester(workId,applierId);
      selectedChats = chatT;
    } catch (error) {
      await makeRequesterChat(workId, applierId);
      selectedChats = await chatsRepository.getChatRequester(workId,applierId);
    }
    selectedChatsOpName = selectedChats?.employeeName;
    selectedChatsOpPhoto = selectedChats?.employeeProfile;
    selectedChatsOpId = selectedChats?.employeeId;
  }

  prepareOpenChat(String chatId, int userid) async {
    Chats? chatT = await chatsRepository.getChat(chatId);
    selectedChats = chatT;
    if (chatT.employeeId == userid) {
      selectedChatsOpName = chatT.employerName;
      selectedChatsOpPhoto = chatT.employerProfile;
      selectedChatsOpId = selectedChats?.employerId;
    } else {
      selectedChatsOpName = selectedChats?.employeeName;
      selectedChatsOpPhoto = selectedChats?.employeeProfile;
      selectedChatsOpId = selectedChats?.employeeId;
    }
  }

  /*
  *
  *
  *
  * */
// 안읽은 채팅 관리
  late StompClient stompClient;
  List<UnreadRoomInfo> unreadRoomInfo = [];
  int unreadCount = 0;

  void readByEnteringChat(String roomId) {
    unreadRoomInfo.forEach((elem) {
      if (elem.roomId == roomId) {
        elem.unreadCount = 0;
      }
    });
    int count = 0;
    unreadRoomInfo.forEach((elem) {
      count = count + elem.unreadCount!;
    });
    unreadCount = count;
    // notifyListeners();
  }

  void setLastChat(String roomId, String message) {
    unreadRoomInfo.forEach((elem) {
      if (elem.roomId == roomId) {
        elem.unreadCount = elem.unreadCount! + 1;
        elem.lastChat = message ?? '';
        elem.lastChatTime = DateTime.now().toIso8601String();
      }
    });
  }

  void subscribeUnreadMessages(int userId, BuildContext context) {
    stompClient = StompClient(
        config: StompConfig(
      url: BASE_WS,
      onConnect: (StompFrame frame) {
        print("unread Controller socket connected");
        stompClient.subscribe(
          destination: "/sub/unread/$userId",
          callback: (frame) {
            // frame.body에는 unread message 정보가 포함되어 있음
            final unreadChat = jsonDecode(frame.body ?? '');
            ChatMessage info = ChatMessage.fromJson(unreadChat);
            print("unreadsocket is ${info.createdAt}");
            updateUnreadMessage(info, context);
          },
        );
      },
      onWebSocketError: (dynamic error) => print(error),
    ));
    stompClient.activate();
  }

  initializeChat() async {
    final res = await ChatsRepository().getUnreadRoomInfo();
    unreadRoomInfo = res;
    int count = 0;
    unreadRoomInfo.forEach((elem) {
      count = count + elem.unreadCount!;
    });
    unreadCount = count;
  }

  updateUnreadMessage(ChatMessage info, BuildContext context) async {
    // 기존 채팅방인 경우 unread 다시 초기화
    if (!unreadRoomInfo.any((room) => room.roomId == info.roomId)) {
      await initializeChat();
      await initialize(context);
    }
    refreshChats(info);
    // 안 읽은 메세지 수 총합
    countUnread();
  }

  void refreshChats(ChatMessage info){
    UnreadRoomInfo unreadRoom =
    unreadRoomInfo.firstWhere((elem) => elem.roomId == info.roomId);

    applyChats = applyChats.map((elem) {
      if (elem.id == info.roomId) {
        elem.lastChatTime = info.createdAt;
      }
      return elem;
    }).toList();
    requestChats = requestChats.map((elem) {
      if (elem.id == info.roomId) {
        elem.lastChatTime = info.createdAt;
      }
      return elem;
    }).toList();
    notifyListeners(); // UI에 변경 사항 알림
    rearrageChat(info);

    // 안 읽은 정보에 카운트 올려주고, 마지막 채팅 내역 저장
    unreadRoom.unreadCount = unreadRoom.unreadCount! + 1;
    unreadRoom.lastChat = info.message ?? '';
    unreadRoom.lastChatTime = info.createdAt;
    // 2. 채팅 순서 재정렬
    print('sort');
    sortChats();
  }

  void rearrageChat(ChatMessage info){
    print("rearrangeChat");

    applyChats = applyChats.map((elem) {
      if (elem.id == info.roomId) {
        elem.lastChatTime = info.createdAt;
      }
      return elem;
    }).toList();
    requestChats = requestChats.map((elem) {
      if (elem.id == info.roomId) {
        elem.lastChatTime = info.createdAt;
      }
      return elem;
    }).toList();

    requestChats.forEach((elem){
      print("TEST 진행 ${elem.lastChatTime}");
    });


    notifyListeners();
  }

  void sortChats() {
    print('sort 진행');
    applyChats.sort((a, b) =>
        DateTime.parse(b.lastChatTime ?? b.modifiedDateTime!)
            .compareTo(DateTime.parse(a.lastChatTime ?? a.modifiedDateTime!)));

    requestChats.sort((a, b) =>
        DateTime.parse(b.lastChatTime ?? b.modifiedDateTime!)
            .compareTo(DateTime.parse(a.lastChatTime ?? a.modifiedDateTime!)));

    notifyListeners();
  }

  void countUnread() {
    int count = 0;
    unreadRoomInfo.forEach((elem) {
      count = count + elem.unreadCount!;
    });
    unreadCount = count;
    notifyListeners();
  }
}
