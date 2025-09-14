import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/providers/posts/Posts.dart';
import 'package:ilkkam/providers/posts/PostsController.dart';
import 'package:ilkkam/providers/posts/PostsRepository.dart';
import 'package:ilkkam/models/res/PostsCategoryDto.dart';
import 'package:ilkkam/utils/imagePicker.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:ilkkam/widgets/ImagePickerWidget.dart';
import 'package:provider/provider.dart';

class CommuWritePage extends StatefulWidget {
  const CommuWritePage({super.key});

  static const routeName = "/CommuWritePage";

  @override
  State<CommuWritePage> createState() => _CommuWritePageState();
}

class _CommuWritePageState extends State<CommuWritePage> {
  PostsRepository commuService = PostsRepository();

  PostsCategoryDto? selectedValue;
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _contentsC = TextEditingController();

  List<String> images = [];
  bool isImageUploading = false;
  bool isUploading = false;

  bool isCategoryUnSelected = false;
  final _formKey = GlobalKey<FormState>();

  Posts? exPost;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Map<String, dynamic> && exPost == null) {
        print(args['post']);
        Posts post = args['post'];
        exPost = post;
        _titleC.text = post?.title ?? '';
        _contentsC.text = post?.contents ?? '';
        PostsController pc =
            Provider.of<PostsController>(context, listen: false);
        selectedValue =
            pc.categories.firstWhere((elem) => elem.id == post.category?.id);
        images = post.images ?? [];
      }
      setState(() {});
    });
    // TODO: implement initState
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postC = Provider.of<PostsController>(context);

    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [_postsCategories(postC.categories)],
            ),
            if (isCategoryUnSelected)
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "게시판을 선택해주세요.",
                  style: TextStyle(color: AppColors.errorColor),
                ),
              ),
            SizedBox(
              height: 20,
            ),
            IkTextField(
              placeholder: "제목 입력 (20자 이내)",
              label: "제목 입력 (필수)",
              controller: _titleC,
              length: 20,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "제목을 입력해주세요.";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            IkTextField(
              placeholder: "내용 입력 (500자 이내)",
              label: "내용 입력 (필수)",
              maxline: 5,
              controller: _contentsC,
              length: 500,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "내용을 입력해주세요.";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            ImagePickerWidget(
              label: "사진등록 (선택)",
              length: 3,
              onDelete: (int idx){
                setState(() {
                images.removeAt(idx);
                });
              },
              count: images.length,
              onTap: () async {
                if(images.length > 2){
                  return;
                }
                setState(() {
                  isImageUploading = true;
                });
                String? imgURL = await pickImage(
                  PickUsageType.COMMUNITY,
                );
                if (imgURL != null) {
                  setState(() {
                    images.add(imgURL);
                  });
                }
                setState(() {
                  isImageUploading = false;
                });
              },
              img: images,
              isImageUploading: isImageUploading,
            ),
            SizedBox(
              height: 60,
            ),
            IKCommonBtn(
                title: "게시글 등록",
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (selectedValue == null ||
                        selectedValue?.id == null ||
                        selectedValue?.name == null) {
                      setState(() {
                        isCategoryUnSelected = true;
                      });
                      return;
                    }
                    if (isUploading) {
                      return;
                    }

                    isUploading = true;
                    // 수정 방식일 때
                    if (exPost != null) {
                      await postC.edit(exPost?.id ?? -1, _titleC.text,
                          _contentsC.text, selectedValue?.id ?? 1, images);
                      postC.refreshSelectedPosts(exPost?.id ?? -1);
                    } else {
                      // 새로만드는 것일 때
                      await postC.save(_titleC.text, _contentsC.text,
                          selectedValue?.id ?? 1, images);
                    }
                    isUploading = false;
                    Navigator.of(context).pop();
                  }
                }),
          ],
        ),
      )),
    );
  }

  Widget _postsCategories(List<PostsCategoryDto> categories) =>
      DropdownButtonHideUnderline(
        child: DropdownButton2<PostsCategoryDto>(
          isExpanded: true,
          hint: const Row(
            children: [
              Expanded(
                child: Text(
                  '게시판 선택',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    // color: Color(0xFFFF7F39),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: categories
              .where((elem) => elem.name != "공지사항" && elem.name != "카테고리 선택")
              .map(
                  (PostsCategoryDto item) => DropdownMenuItem<PostsCategoryDto>(
                        value: item,
                        child: Text(
                          item.name ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF41474A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 44,
            width: MediaQuery.of(context).size.width-40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFFE1E1E1),
                ),
                // color: Color(0xFF0FFEBE0)
            ),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down_sharp,
              size: 24,
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            // width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                // color: Colors.redAccent,
                color: Colors.white
            ),
            // offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      );
}
