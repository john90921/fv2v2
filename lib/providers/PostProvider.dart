import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/models/Comment.dart';
import 'package:fv2/models/Reply.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PostProvider extends ChangeNotifier {
  bool isLoading = false;
  bool success = false;
  List<Post> _postList = [];
  bool isLoadingMore = false;
  List<Post> get postList => _postList;

  int pages =1;
  bool hasMore = true;

  void setPostList(List<Post> value) {
    _postList = value;
  }

  Post? getPost(int id) {
    try {
      return _postList.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<String?> likePost(int postId) async {
    final index = postList.indexWhere((p) => p.id == postId);
    // get the index of the post that has the postID from the postList
    print(index);
    if (index == -1) {
      return "Post not found";
    }
    postList[index].isLiked =
        !postList[index].isLiked; // if liked then change to false else true
    if (postList[index].isLiked) {
      postList[index].likesCount += 1; // if liked then increment else decrement
    } else {
      postList[index].likesCount -=
          1; // if disliked then decrement else increment}
    }
    notifyListeners();
    try {
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/likes", data: {"id": postId, "type": "post"}),
      );
      if (result.status != true) {
        // re
        postList[index].isLiked = !postList[index].isLiked;
        if (postList[index].isLiked) {
          postList[index].likesCount += 1;
        } else {
          postList[index].likesCount -= 1;
        }
        notifyListeners();
        return " error : ${result.message}";
      }
    } catch (e) {
      return ("error $e");
    }
  }

  addCommentsCount(int postId) {
    final index = postList.indexWhere((p) => p.id == postId);
    print(index);
    postList[index].commentsCount += 1;
    notifyListeners();
  }
  minusCommentsCount(int postId) {
    final index = postList.indexWhere((p) => p.id == postId);
    print(index);
    postList[index].commentsCount -= 1;
    notifyListeners();
  }

//   addNewPost(
//     String title,
//     String content,
//     String? imagePath,
//     BuildContext context,
//   ) async {
//     try {
//   FormData formData = FormData.fromMap({
//     'title': title,
//     'content': content,
//     'image': imagePath != null
//         ? await MultipartFile.fromFile(imagePath, filename: 'upload.jpg')
//         : null,
//   });
//   ApiResult result = await Apihelper.post(
//       ApiRequest(
//         path: "/post",
//         data: formData,
//       ),
//     );
//     print(result.message);
// } on Exception catch (e) {
// print("error $e");
//   // TODO
// }


//   }
addNewPost(
  String title,
  String content,
  String? imagePath,
  BuildContext context,
) async {
  try { // Show loading overlay

    // Create form data for Dio
    FormData formData = FormData.fromMap({
      'title': title,
      'content': content,
      if (imagePath != null)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: 'upload.jpg',
        ),
    });

    // Send POST request
    ApiResult result = await Apihelper.post(
      ApiRequest(
        path: "/post",
        data: formData,
      ),
    );

 
    if (result.status == true) {
      Map<String, dynamic> data =
            result.data as Map<String, dynamic>;

      print(data);
      Post post = Post.fromMap(data);
      postList.insert(0, post);
       //get the post list data as a list
      // Example: refresh posts or show a success message
      
      // Optionally refresh UI
      notifyListeners();
      return "success added post";
    } else {
      return ("error ${result.message}");  
    }
  } catch (e) {
    return ("error $e");
  }
}
Future<String?> editPost(
    {required Post post,
    required String title,
    required String content,
    required String? newImagePath,}
  ) async {
  print("edit post");
  try {
  FormData formData;

    formData = FormData.fromMap({ // if new image selected or delered image before, then send image field
    'title': title,
    'content': content,
    '_method': 'PATCH',
    if (newImagePath == null && post.image == null)
    'remove_image': true,
    if (newImagePath != null)
    'image': await MultipartFile.fromFile(newImagePath, filename: 'post.jpg'), //if new image selected
  });

     ApiResult result = await Apihelper.patch(
        ApiRequest(
          path: "/post/${post.id}",
          data: formData,
        )
      );
      if(result.status == true){
        print(result.data);
        Map<String, dynamic> data =
            result.data as Map<String, dynamic>;
        print("update ${result.data}");
        Post updatedPost = Post.fromMap(data);
        final index = postList.indexWhere((p) => p.id == post.id);
        if(index != -1){
          postList[index] = updatedPost;
          notifyListeners();
        }
        return ("success edited post");
      } else{
        return ("error ${result.message}");
      }
} on Exception catch (e) {
  // TODO
  return ("error $e");
}

  }

  Future<String> deletePost(int id, BuildContext context) async {
    // id post
    context.loaderOverlay.show(); // show the loader overlay
    try {
      ApiResult result = await Apihelper.delete(
        ApiRequest(path: "/post/$id"),
      ); // delete the post
      if (result.status == true) {
        success = true;
        // optionally remove the deleted post from list
        postList.removeWhere((post) => post.id == id);

        context.loaderOverlay.hide();
        notifyListeners();
        return "Post deleted successfully";
      } else {
        return ("Delete failed: ${result.message}");
      }
    } catch (e) {
      return ("error $e");
    }
  }

  List<Post> parsePosts(List<dynamic> data) {
    return data
        .map((item) => Post.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  LoadMoreTodayPostsData() async{
    try{
      if (isLoadingMore || !hasMore) return;
      pages++;
      hasMore = true;
      isLoadingMore = true;
      ApiResult result = await Apihelper.get(ApiRequest(path: "/todayPosts?page=$pages"));
      if (result.data is List) {
        // check if data is a list
        List<dynamic> data =
            result.data as List<dynamic>; //get the post list data as a list
        List<Post> posts = parsePosts(data);
        if(posts.isEmpty){
          hasMore = false;
        } else{
          _postList.addAll(posts);
        }
    
      } else {
        print("no list data"); // if data is not a list
      }
    }
    catch(e){
      print("error $e");
    } 
    finally{
      isLoadingMore = false;
      notifyListeners();
    }
  }

  getTodayPostsData() async {
    try {
      pages = 1;
      isLoading = true;
      notifyListeners(); // Notify listeners that data is loading
      ApiResult result = await Apihelper.get(ApiRequest(path: "/todayPosts"));
      if (result.data is List) {
        // check if data is a list
        List<dynamic> data =  
            result.data as List<dynamic>; //get the post list data as a list
        List<Post> posts =[];
          for (var item in data) { // loop post through the post list
            posts.add(Post.fromMap(item as Map<String, dynamic>)); // add each post to the post list
        }

        setPostList(posts); // set the post list with the parsed post list
      } else {
        print("no data"); // if data is not a list
      }
      print(postList.length);
    } catch (e) {
      print("error $e"); // handle errors
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners that data is loaded
    }
  }
}
