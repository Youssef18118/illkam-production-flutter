// import 'package:flutter/material.dart';

// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:ilkkam/providers/posts/Posts.dart';
// import 'package:ilkkam/providers/posts/PostsController.dart';
// import 'package:ilkkam/models/res/PostsCategoryDto.dart';
// import 'package:ilkkam/pages/community/CommuDetailPage.dart';
// import 'package:ilkkam/pages/community/CommuWritePage.dart';
// import 'package:ilkkam/providers/TabController.dart';
// import 'package:ilkkam/providers/users/UserController.dart';
// import 'package:ilkkam/widgets/IKBlankDivider.dart';
// import 'package:intl/intl.dart';
// import 'package:ilkkam/utils/styles.dart';
// import 'package:provider/provider.dart';

// import 'widgets/ArticleLabel.dart';

// class CommuListpage extends StatefulWidget {
//   const CommuListpage({super.key});

//   static const routeName = "/CommuListpage";

//   @override
//   State<CommuListpage> createState() => _CommuListpageState();
// }

// class _CommuListpageState extends State<CommuListpage> {
//   PostsCategoryDto? selectedValue;

//   // @override
//   // void initState() {
//   //   Provider.of<PostsController>(context, listen: false).initialize();
//   //   // TODO: implement initState
//   //   super.initState();
//   // }
//   @override
//   void initState() {
//     super.initState();
//     // Use addPostFrameCallback to ensure the context is available
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final postC = Provider.of<PostsController>(context, listen: false);
//       // Only fetch data if the list is currently empty
//       if (postC.posts.isEmpty) {
//         postC.initialize();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tabs = Provider.of<TabUIController>(context, listen: false);
//     final postC = Provider.of<PostsController>(context);
//     final userC = Provider.of<UserController>(context);
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         title: Text(
//           '커뮤니티',
//           style: TextStyle(
//             color: Color(0xFF121212),
//             fontSize: 24,
//             fontFamily: 'Pretendard',
//             fontWeight: FontWeight.w600,
//             height: 1.42,
//           ),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: RefreshIndicator(
//           onRefresh: () async {
//             postC.reloadClear();
//             postC.reload(reqPage: 0);
//           },
//           child: Stack(
//             children: [
//               NotificationListener<ScrollUpdateNotification>(
//                   onNotification: (ScrollUpdateNotification notification) {
//                     postC.listner(notification);
//                     return false;
//                   },
//                   child: SingleChildScrollView(
//                     child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 20),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: 70,
//                             ),
//                             Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 20, vertical: 28),
//                                 child: ListView.separated(
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   separatorBuilder:
//                                       (BuildContext ctx, int index) {
//                                     return Divider(
//                                       color: AppColors.dividerColor,
//                                       height: 40,
//                                     );
//                                   },
//                                   itemBuilder: (BuildContext ctx, int index) {
//                                     Posts res = postC.posts[index];
//                                     return _listItem(res, tabs, userC.id);
//                                   },
//                                   itemCount: postC.posts.length,
//                                 )),
//                             SizedBox(
//                               height: 66,
//                             )
//                           ],
//                         )),
//                   )),
//               _postsCategories(postC.categories, postC.selectCategory),
//             ],
//           )),
//       floatingActionButton: _fab(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }

//   Widget _listItem(Posts post, TabUIController tabs, int userid) =>
//       GestureDetector(
//         onTap: () async {
//           if ((post.category?.name?.startsWith("1:1") ?? false) &&
//               post.writer?.id != userid) {
//             return;
//           }
//           await Provider.of<PostsController>(context, listen: false)
//               .refreshSelectedPosts(post.id ?? -1);
//           Navigator.of(context)
//               .pushNamed(
//                 CommuDetailPage.routeName,
//               )
//               .then((v) => tabs.setVisibility(false));
//         },
//         // height: 90,
//         child: (post.category?.name?.startsWith("1:1") ?? false) &&
//                 post.writer?.id != userid
//             ? Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         if (post.category != null)
//                           Row(
//                             children: [ArticleLabel(dto: post.category!)],
//                           ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                                 child: Text(
//                               "작성자만 조회 가능합니다.",
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Color(0xFF191919),
//                                 fontSize: 16,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             )),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "",
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: Color(0xFF7D7D7D),
//                             fontSize: 14,
//                             fontFamily: 'Pretendard',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               post.writer?.name ?? '',
//                               style: TextStyle(
//                                 color: Color(0xFF191919),
//                                 fontSize: 16,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   DateFormat('MM.dd (E) HH:mm', 'ko').format(
//                                       DateTime.parse(post.createdDateTime ??
//                                               "2024-09-25")
//                                           .add(Duration(hours: 9))),
//                                   style: TextStyle(
//                                     color: Color(0xFF494949),
//                                     fontSize: 14,
//                                     fontFamily: 'Pretendard',
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 1,
//                                   height: 8,
//                                   margin: EdgeInsets.symmetric(horizontal: 8),
//                                   decoration:
//                                       BoxDecoration(color: Color(0xFFD9D9D9)),
//                                 ),
//                                 Container(
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 16,
//                                         height: 16,
//                                         decoration: BoxDecoration(),
//                                         child: SvgPicture.asset(
//                                             "assets/community/comments.svg"),
//                                       ),
//                                       Text(
//                                         '${post.replies?.length} ',
//                                         style: TextStyle(
//                                           color: Color(0xFF545454),
//                                           fontSize: 12,
//                                           fontFamily: 'Pretendard',
//                                           fontWeight: FontWeight.w500,
//                                           letterSpacing: -0.12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               )
//             : Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         if (post.category != null)
//                           Row(
//                             children: [ArticleLabel(dto: post.category!)],
//                           ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                                 child: Text(
//                               post.title ?? '',
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Color(0xFF191919),
//                                 fontSize: 16,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             )),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           post.contents ?? '',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: Color(0xFF7D7D7D),
//                             fontSize: 14,
//                             fontFamily: 'Pretendard',
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               post.writer?.name ?? '',
//                               style: TextStyle(
//                                 color: Color(0xFF191919),
//                                 fontSize: 16,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   DateFormat('MM.dd (E) HH:mm', 'ko').format(
//                                       DateTime.parse(post.createdDateTime ??
//                                               "2024-09-25")
//                                           .add(Duration(hours: 9))),
//                                   style: TextStyle(
//                                     color: Color(0xFF494949),
//                                     fontSize: 14,
//                                     fontFamily: 'Pretendard',
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 1,
//                                   height: 8,
//                                   margin: EdgeInsets.symmetric(horizontal: 8),
//                                   decoration:
//                                       BoxDecoration(color: Color(0xFFD9D9D9)),
//                                 ),
//                                 Container(
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 16,
//                                         height: 16,
//                                         decoration: BoxDecoration(),
//                                         child: SvgPicture.asset(
//                                             "assets/community/comments.svg"),
//                                       ),
//                                       Text(
//                                         '${post.replies?.length} ',
//                                         style: TextStyle(
//                                           color: Color(0xFF545454),
//                                           fontSize: 12,
//                                           fontFamily: 'Pretendard',
//                                           fontWeight: FontWeight.w500,
//                                           letterSpacing: -0.12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//       );

//   Widget _fab() => GestureDetector(
//         onTap: () => Navigator.of(context).pushNamed(CommuWritePage.routeName),
//         child: Container(
//           // width: 71,
//           height: 38,
//           margin: EdgeInsets.only(bottom: 86),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           clipBehavior: Clip.antiAlias,
//           decoration: ShapeDecoration(
//               shape: RoundedRectangleBorder(
//                 side: BorderSide(width: 1, color: Color(0xFF01A9DB)),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               color: Colors.white),
//           child: Text(
//             '글쓰기',
//             style: TextStyle(
//               color: Color(0xFF01A9DB),
//               fontSize: 15,
//               fontFamily: 'Pretendard',
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       );

//   Widget _postsCategories(List<PostsCategoryDto> categories, Function selectCategory) =>
//       Container(
//         child: Column(
//           children: [
//             Container(
//               height: 70,
//               color: Colors.white,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 itemBuilder: (BuildContext ctx, int index) {
//                   PostsCategoryDto category = categories[index];
//                   if (index == 0) {
//                     return GestureDetector(
//                       onTap: () {
//                         selectCategory(category.id ?? 1);
//                       },
//                       child: Container(
//                           child: Image.asset("assets/common/cm_$index.png")),
//                     );
//                   }

//                   return GestureDetector(
//                     onTap: () {
//                       selectCategory( category.id ?? 1);
//                     },
//                     child: Container(
//                         child: Image.asset("assets/common/cm_$index.png")),
//                   );
//                 },
//                 itemCount: categories.length,
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               child: IKBlankDivider(
//                 margin: 20,
//               ),
//             )
//           ],
//         ),
//       );
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/providers/posts/Posts.dart';
import 'package:ilkkam/providers/posts/PostsController.dart';
import 'package:ilkkam/models/res/PostsCategoryDto.dart';
import 'package:ilkkam/pages/community/CommuDetailPage.dart';
import 'package:ilkkam/pages/community/CommuWritePage.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/widgets/IKBlankDivider.dart';
import 'package:intl/intl.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:ilkkam/pages/register/LandingPage.dart' as RegisterLandingPage;

import 'widgets/ArticleLabel.dart';

class CommuListpage extends StatefulWidget {
  const CommuListpage({super.key});

  static const routeName = "/CommuListpage";

  @override
  State<CommuListpage> createState() => _CommuListpageState();
}

class _CommuListpageState extends State<CommuListpage> {
  PostsCategoryDto? selectedValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final postC = Provider.of<PostsController>(context, listen: false);
      if (postC.posts.isEmpty) {
        postC.initialize();
      }
    });
  }

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
    final tabs = Provider.of<TabUIController>(context, listen: false);
    final postC = Provider.of<PostsController>(context);
    final userC = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          '커뮤니티',
          style: TextStyle(
            color: Color(0xFF121212),
            fontSize: 24,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.42,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
          onRefresh: () async {
            postC.reloadClear();
            postC.reload(reqPage: 0);
          },
          child: Stack(
            children: [
              NotificationListener<ScrollUpdateNotification>(
                  onNotification: (ScrollUpdateNotification notification) {
                    postC.listner(notification);
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 28),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (BuildContext ctx, int index) {
                                    return Divider(
                                      color: AppColors.dividerColor,
                                      height: 40,
                                    );
                                  },
                                  itemBuilder: (BuildContext ctx, int index) {
                                    Posts res = postC.posts[index];
                                    return _listItem(res, tabs, userC);
                                  },
                                  itemCount: postC.posts.length,
                                )),
                            SizedBox(
                              height: 66,
                            )
                          ],
                        )),
                  )),
              _postsCategories(postC.categories, postC.selectCategory),
            ],
          )),
      floatingActionButton: _fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _listItem(Posts post, TabUIController tabs, UserController userC) =>
      GestureDetector(
        onTap: () {
          _handleProtectedAction(() async {
            if ((post.category?.name?.startsWith("1:1") ?? false) &&
                post.writer?.id != userC.id) {
              return;
            }
            await Provider.of<PostsController>(context, listen: false)
                .refreshSelectedPosts(post.id ?? -1);
            Navigator.of(context)
                .pushNamed(
                  CommuDetailPage.routeName,
                )
                .then((v) => tabs.setVisibility(false));
          });
        },
        child: (post.category?.name?.startsWith("1:1") ?? false) &&
                !userC.isLogIn
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (post.category != null)
                          Row(
                            children: [ArticleLabel(dto: post.category!)],
                          ),
                        const SizedBox(height: 8),
                        Text(
                          "로그인 후 확인 가능한 게시글입니다.",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF7D7D7D),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (post.category != null)
                          Row(
                            children: [ArticleLabel(dto: post.category!)],
                          ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              post.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF191919),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.contents ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF7D7D7D),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              post.writer?.name ?? '',
                              style: TextStyle(
                                color: Color(0xFF191919),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  DateFormat('MM.dd (E) HH:mm', 'ko').format(
                                      DateTime.parse(post.createdDateTime ??
                                              "2024-09-25")
                                          .add(Duration(hours: 9))),
                                  style: TextStyle(
                                    color: Color(0xFF494949),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 8,
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration:
                                      BoxDecoration(color: Color(0xFFD9D9D9)),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(),
                                        child: SvgPicture.asset(
                                            "assets/community/comments.svg"),
                                      ),
                                      Text(
                                        '${post.replies?.length} ',
                                        style: TextStyle(
                                          color: Color(0xFF545454),
                                          fontSize: 12,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
      );

  Widget _fab() => GestureDetector(
        onTap: () {
          _handleProtectedAction(() {
            Navigator.of(context).pushNamed(CommuWritePage.routeName);
          });
        },
        child: Container(
          height: 38,
          margin: EdgeInsets.only(bottom: 86),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFF01A9DB)),
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white),
          child: Text(
            '글쓰기',
            style: TextStyle(
              color: Color(0xFF01A9DB),
              fontSize: 15,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  Widget _postsCategories(List<PostsCategoryDto> categories, Function selectCategory) =>
      Container(
        child: Column(
          children: [
            Container(
              height: 70,
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext ctx, int index) {
                  PostsCategoryDto category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      selectCategory(category.id ?? 1);
                    },
                    child: Container(
                        // Assuming you have images like cm_0.png, cm_1.png etc.
                        child: Image.asset("assets/common/cm_$index.png")),
                  );
                },
                itemCount: categories.length,
              ),
            ),
            Container(
              color: Colors.white,
              child: IKBlankDivider(
                margin: 20,
              ),
            )
          ],
        ),
      );
}