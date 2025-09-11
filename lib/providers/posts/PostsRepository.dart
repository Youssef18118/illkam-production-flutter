import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/models/req/SavePostsRequestDto.dart';
import 'package:ilkkam/models/res/PostsCategoryDto.dart';
import 'package:ilkkam/providers/posts/Posts.dart';

class PostsRepository {
  final BaseAPI baseAPI = BaseAPI();

  // Future<List<Posts>> getPosts({int category = 1, int page=0}) async {
  //   print('게시글 데이터 불러오기');
  //   print("category is $category and page is $page");
  //   final resJson = await baseAPI.basicGet("posts/?category=$category&page=$page");
  //   List<Posts> result = [];
  //   resJson.forEach((v) {
  //     result.add(new Posts.fromJson(v));
  //   });
  //   return result;
  // }

  Future<List<Posts>> getPosts({int category = 1, int page=0}) async {
    print('게시글 데이터 불러오기');
    print("category is $category and page is $page");
    final resJson = await baseAPI.basicGet("posts/?category=$category&page=$page");
    List<Posts> result = [];

    // FIX: Add null check for guest users
    if (resJson == null) {
      return []; // Return empty list to prevent crash
    }

    resJson.forEach((v) {
      result.add(new Posts.fromJson(v));
    });
    return result;
  }

  // Future<List<PostsCategoryDto>> getCategories() async {
  //   print('게시글 카테고리 불러오기');
  //   final resJson = await baseAPI.basicGet("posts/category");
  //   print(resJson);
  //   List<PostsCategoryDto> result = [

  //   ];


  //   resJson.forEach((v) {
  //     result.add(PostsCategoryDto.fromJson(v));
  //   });
  //   return result;
  // }

  Future<List<PostsCategoryDto>> getCategories() async {
    print('게시글 카테고리 불러오기');
    final resJson = await baseAPI.basicGet("posts/category");
    print(resJson);
    List<PostsCategoryDto> result = [];

    // FIX: Add null check for guest users
    if (resJson == null) {
      return []; // Return empty list to prevent crash
    }

    resJson.forEach((v) {
      result.add(PostsCategoryDto.fromJson(v));
    });
    return result;
  }

  Future<void> savePosts(
      {required String title,
      required String contents,
      required int category,
      required List<String> images}) async {
    print('게시글 저장하기');
    int writer = await baseAPI.getJWT() ?? 1;
    SavePostsRequestDto dto = SavePostsRequestDto(
        title: title,
        contents: contents,
        categoryId: category,
        writer: writer,
        images: images);
    print(dto.images);
    final resJson = await baseAPI.basicPost("posts/", dto.toJson());
    await getPosts();

    return resJson;
  }

  Future<Posts> getOnePosts(int post_id) async {
    print('게시글 넘버 ${post_id} 불러오기');
    final resJson = await baseAPI.basicGet("posts/${post_id}");

    return Posts.fromJson(resJson);
  }

  Future<void> replyPost(int post_id, String contents) async {
    print('게시글 데이터 불러오기');
    int writer = await baseAPI.getJWT() ?? 1;
    await baseAPI.basicPost("posts/${post_id}/reply",
        {"user_id": writer, "contents": contents, "post_id": post_id});
  }
  Future<void> removePost(int post_id)async {
    int writer = await baseAPI.getJWT() ?? 1;
    await baseAPI.basicDelete("posts/${post_id}");
  }

  Future<void> editPost(
      {
        required int post_id,
        required String title,
        required String contents,
        required int category,
        required List<String> images}) async {
    print('게시글 저장하기');
    int writer = await baseAPI.getJWT() ?? 1;
    SavePostsRequestDto dto = SavePostsRequestDto(
        title: title,
        contents: contents,
        categoryId: category,
        writer: writer,
        images: images);
    print(dto.images);
    final resJson = await baseAPI.basicPut("posts/${post_id}", dto.toJson());
    return resJson;
  }


}
