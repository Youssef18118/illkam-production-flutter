import 'package:flutter/material.dart';
import 'package:ilkkam/models/res/PostsCategoryDto.dart';
import 'package:ilkkam/providers/posts/Posts.dart';
import 'package:ilkkam/providers/posts/PostsRepository.dart';

class PostsController with ChangeNotifier {
  final PostsRepository postsRepository = PostsRepository();
  bool _visible = true;

  bool get visible => _visible;

  Posts? selectedPosts;
  List<Posts> posts = [];
  List<PostsCategoryDto> categories = [];

  int page = 0;
  bool isLoading = false;
  bool hasMore = true;

  int category = 1;

  void listner(ScrollUpdateNotification notification) {
    if (notification.metrics.maxScrollExtent * 0.85 <
        notification.metrics.pixels && hasMore) {
      print('listner happend');
      if(isLoading){
        return;
      }
      print('listner actions');
      isLoading = true;
      reload(reqPage: page);
    }
  }

  void setVisibility(bool visible) {
    _visible = visible;

    notifyListeners();
  }

  initialize() async {
    await getCategories();
    await reload();
  }

  Future getCategories() async {
    categories = await postsRepository.getCategories();
    notifyListeners();
  }

  Future save(
      String title, String contents, int category, List<String> images) async {
    await postsRepository.savePosts(
        title: title, contents: contents, category: category, images: images);
    reload();
  }

  Future edit(int id,
      String title, String contents, int category, List<String> images) async {
    await postsRepository.editPost(
      post_id:  id,
        title: title, contents: contents, category: category, images: images);
    reload();
  }

  selectCategory(int cate){
    category = cate;
    hasMore = false;
    page =0 ;
    reload();
  }

  reloadClear(){
    page = 0;
    isLoading = false;
    hasMore = true;
  }

  Future reload({int reqPage = 0}) async {
    isLoading = true;
    notifyListeners();
    List<Posts> newPosts = await postsRepository.getPosts(category: category,page: page);
    if(page != 0){
      posts.addAll(newPosts);
    }else{
      posts = newPosts;
      hasMore = true;
      page =0;
    }
    hasMore = newPosts.length == 10;
    if(hasMore){
      page++;
    }
    isLoading = false;
    notifyListeners();

  }

  Future<void> refreshSelectedPosts(int post_id) async {
    postsRepository.getOnePosts(post_id).then((v) {
      if (v != null) {
        selectedPosts = v;
        notifyListeners();
      }
    });
  }

  Future<void> reply(String content) async {
    await postsRepository.replyPost(selectedPosts!.id!, content);
    refreshSelectedPosts(
      selectedPosts!.id!,
    );
  }
}
