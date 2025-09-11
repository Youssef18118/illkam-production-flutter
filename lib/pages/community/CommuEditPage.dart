import 'package:flutter/material.dart';
import 'package:ilkkam/models/res/PostsCategoryDto.dart';
import 'package:ilkkam/providers/posts/Posts.dart';
import 'package:ilkkam/providers/posts/PostsRepository.dart';

class CommuEditPage extends StatefulWidget {
  static const routeName= "/commu-edit-page";
  const CommuEditPage({super.key});

  @override
  State<CommuEditPage> createState() => _CommuEditPageState();
}

class _CommuEditPageState extends State<CommuEditPage> {
  PostsRepository commuService = PostsRepository();

  PostsCategoryDto? selectedValue;
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _contentsC = TextEditingController();

  List<String> images = [];
  bool isImageUploading = false;
  bool isUploading = false;

  bool isCategoryUnSelected = false;
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
