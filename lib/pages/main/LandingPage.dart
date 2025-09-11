// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:ilkkam/apis/base.dart';
// import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';
// import 'package:ilkkam/pages/main/UploadWorkPage.dart';
// import 'package:ilkkam/pages/main/WorkListPage.dart';
// import 'package:ilkkam/pages/main/widgets/IKCategoryLists.dart';
// import 'package:ilkkam/pages/main/widgets/WorkDayCountWidget.dart';
// import 'package:ilkkam/pages/main/widgets/WorkFilters.dart';
// import 'package:ilkkam/providers/users/UserController.dart';
// import 'package:ilkkam/providers/works/WorkController.dart';
// import 'package:ilkkam/providers/works/WorkRepository.dart';
// import 'package:ilkkam/utils/styles.dart';
// import 'package:ilkkam/widgets/IKBlankDivider.dart';
// import 'package:ilkkam/widgets/WorkItem.dart';
// import 'package:provider/provider.dart';

// class MainHomePage extends StatefulWidget {
//   const MainHomePage({super.key});

//   @override
//   State<MainHomePage> createState() => _MainHomePageState();
// }

// class _MainHomePageState extends State<MainHomePage> {
//   WorkRepository workRepository = WorkRepository();
//   BaseAPI baseAPI = BaseAPI();

//   List<WorkInfoDetail> workInfoDetails = [];

//   // @override
//   // void initState() {
//   //   Provider.of<WorkController>(context, listen: false).initializeFilters();
//   //   baseAPI.getJWT().then((v) =>
//   //       Provider.of<UserController>(context, listen: false).setUserId(v));
//   //   super.initState();
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // Use addPostFrameCallback to ensure the context is available
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final workController = Provider.of<WorkController>(context, listen: false);
//       final userController = Provider.of<UserController>(context, listen: false);
  
//       // Initialize filters for everyone
//       workController.initializeFilters();
      
//       // Only reload data if the list is empty to avoid refetching on tab switch
//       if (workController.recentWorks.isEmpty) {
//         workController.reload();
//       }
  
//       // This part is for logged-in users, it's fine to keep
//       baseAPI.getJWT().then((v) => userController.setUserId(v));
//     });
//   }


//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final work = Provider.of<WorkController>(context);
//     final user = Provider.of<UserController>(context);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Container(
//             padding: EdgeInsets.all(20),
//             child: RefreshIndicator(
//                 key: landingRefreshKey,
//                 onRefresh: () async {
//                   work.selectedProvince = null;
//                   work.selectedWorkDetailType = null;
//                   work.selectedWorkType = null;
//                   await work.reload();
//                 },
//                 child: NotificationListener<ScrollUpdateNotification>(
//                     onNotification: (ScrollUpdateNotification notification) {
//                       work.listner(notification);
//                       return false;
//                     },
//                     child: SingleChildScrollView(
//                       controller: work.landingPageScrollC,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           IkCategoryLists(),
//                           IKBlankDivider(
//                             margin: 20,
//                           ),
//                           Container(
//                             padding: const EdgeInsets.only(top: 0, bottom: 20),
//                             child: Column(children: [
//                               WorkFilters(
//                                 isLandingPage: true,
//                               ),
//                               WorkDayCountWidget(
//                                 isLandingPage: true,
//                               ),
//                             ]),
//                           ),

//                           IKBlankDivider(
//                             margin: 0,
//                           ),
//                           // 아래쪽 최근 등록된 일깜
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text.rich(
//                                       TextSpan(children: [
//                                         const TextSpan(
//                                           text: '최근 등록된  ',
//                                           style: TextStyle(
//                                             color: Color(0xFF121212),
//                                             fontSize: 19,
//                                             fontFamily: 'Pretendard',
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         TextSpan(
//                                             text: '일깜',
//                                             style: IKTextStyle.appMainText),
//                                       ]),
//                                     ),
//                                     MaterialButton(
//                                       minWidth: 0,
//                                       visualDensity: VisualDensity.compact,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5)),
//                                       onPressed: () {
//                                         Provider.of<WorkController>(context,
//                                                 listen: false)
//                                             .changeMonth(DateTime.now(),
//                                                 fromDayCount: true);
//                                         Navigator.of(context)
//                                             .pushNamed(WorkListPage.routeName);
//                                       },
//                                       child: Row(
//                                         children: [
//                                           Text(
//                                             "더보기",
//                                             style: TextStyle(
//                                               color: const Color(0xFF7D7D7D),
//                                               fontSize: 14,
//                                               fontFamily: 'Pretendard',
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           Icon(Icons.chevron_right, )
//                                         ],
//                                       )
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ListView.separated(
//                               physics: const NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               separatorBuilder: (BuildContext ctx, int index) {
//                                 return Divider(
//                                   color: Color(0xFFE0E0E0),
//                                   height: 30,
//                                 );
//                               },
//                               itemCount: work.recentWorks.length + 1,
//                               itemBuilder: (context, index) {
//                                 if (index == work.recentWorks.length) {
//                                   return SizedBox(
//                                     height: 87,
//                                   );
//                                 }
//                                 return WorkItem(
//                                   work: work.recentWorks[index],
//                                   isGuest: !user.isLogIn,
//                                 );
//                               }),
//                           // Expanded(
//                           //     child: )
//                         ],
//                       ),
//                     ))),
//           ),
//           Positioned(
//               right: 16,
//               bottom: 100,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       work.landingPageScrollC.animateTo(0,
//                           duration: Duration(milliseconds: 300),
//                           curve: Curves.easeInOut);
//                     },
//                     child: SvgPicture.asset("assets/main/arrow_btn_up.svg"),
//                   ),
//                   SizedBox(
//                     height: 12,
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       Navigator.of(context).pushNamed(UploadWorkPage.routeName);
//                     },
//                     elevation: 0,
//                     minWidth: 0,
//                     padding: const EdgeInsets.only(
//                         top: 15, left: 20, right: 12, bottom: 15),
//                     color: const Color(0xFF01A9DB),
//                     shape: RoundedRectangleBorder(
//                       // side: BorderSide(width: 1, color: Color(0xFF01A9DB)),
//                       borderRadius: BorderRadius.circular(45),
//                     ),
//                     child: Container(
//                       decoration: ShapeDecoration(
//                         // color: Color(0xFF01A9DB),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(45),
//                         ),
//                       ),
//                       child: const Row(
//                         children: [
//                           Text(
//                             '일깜등록',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontFamily: 'Pretendard',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(width: 4),
//                           Icon(
//                             Icons.add,
//                             color: Colors.white,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
// }

// lib/pages/main/LandingPage.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';
import 'package:ilkkam/pages/main/UploadWorkPage.dart';
import 'package:ilkkam/pages/main/WorkListPage.dart';
import 'package:ilkkam/pages/main/widgets/IKCategoryLists.dart';
import 'package:ilkkam/pages/main/widgets/WorkDayCountWidget.dart';
import 'package:ilkkam/pages/main/widgets/WorkFilters.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/WorkRepository.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKBlankDivider.dart';
import 'package:ilkkam/widgets/WorkItem.dart';
import 'package:provider/provider.dart';
import 'package:ilkkam/pages/register/LandingPage.dart' as RegisterLandingPage;

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final GlobalKey<RefreshIndicatorState> landingRefreshKey = GlobalKey<RefreshIndicatorState>();

  WorkRepository workRepository = WorkRepository();
  BaseAPI baseAPI = BaseAPI();

  List<WorkInfoDetail> workInfoDetails = [];
  late final ScrollController _scrollController;
  late final WorkController _workController;



  @override
void initState() {
  super.initState();

  _workController = Provider.of<WorkController>(context, listen: false);

  // 1. Create the controller here, inside the widget's state
  _scrollController = ScrollController();
  
  // 2. Assign the reference to the provider
  _workController.landingPageScrollC = _scrollController; 
  
  // Use addPostFrameCallback to ensure the context is available
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final userController = Provider.of<UserController>(context, listen: false);

    // Initialize filters for everyone
    _workController.initializeFilters();
    
    // Only reload data if the list is empty to avoid refetching on tab switch
    if (_workController.recentWorks.isEmpty) {
      _workController.reload();
    }

    // This part is for logged-in users, it's fine to keep
    baseAPI.getJWT().then((v) => userController.setUserId(v));
  });
}

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  void dispose() {
    // 3. IMPORTANT: Clear the reference in the provider
    if (_workController.landingPageScrollC == _scrollController) {
      _workController.landingPageScrollC = null;
    }
    
    // 4. Dispose of the controller
    _scrollController.dispose();
    super.dispose();
  }

  // ADD THIS HELPER FUNCTION
  void _handleProtectedAction(VoidCallback onAuthenticated) {
    final userController = Provider.of<UserController>(context, listen: false);
    if (userController.isLogIn) {
      onAuthenticated();
    } else {
      Navigator.pushNamed(context, RegisterLandingPage.LandingPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final work = Provider.of<WorkController>(context);
    // ADD THIS LINE
    final userController = Provider.of<UserController>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: RefreshIndicator(
                key: landingRefreshKey,
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
                              // --- START CHANGE HERE ---
                              GestureDetector(
                                onTap: () {
                                  // This will only trigger the login prompt for guests
                                  if (!userController.isLogIn) {
                                    _handleProtectedAction(() {});
                                  }
                                },
                                child: AbsorbPointer(
                                  absorbing: !userController.isLogIn,
                                  child: WorkFilters(
                                    isLandingPage: true,
                                  ),
                                ),
                              ),
                              // --- END CHANGE HERE ---
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
                                    // --- START CHANGE HERE ---
                                    MaterialButton(
                                      minWidth: 0,
                                      visualDensity: VisualDensity.compact,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      onPressed: () {
                                        // "더보기" should be public, no change needed here.
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
                                    // --- END CHANGE HERE ---
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
                                  isGuest: !userController.isLogIn,  // ADD THIS LINE
                                );
                              }),
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
                      _scrollController.animateTo(0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: SvgPicture.asset("assets/main/arrow_btn_up.svg"),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // --- START CHANGE HERE ---
                  MaterialButton(
                    onPressed: () {
                      _handleProtectedAction(() {
                        Navigator.of(context).pushNamed(UploadWorkPage.routeName);
                      });
                    },
                    // --- END CHANGE HERE ---
                    elevation: 0,
                    minWidth: 0,
                    padding: const EdgeInsets.only(
                        top: 15, left: 20, right: 12, bottom: 15),
                    color: const Color(0xFF01A9DB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Container(
                      decoration: ShapeDecoration(
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