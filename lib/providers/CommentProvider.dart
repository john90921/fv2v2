import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/models/Comment.dart';
import 'package:fv2/models/Reply.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CommentProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Comment> _comments = [];
  bool isAddingComment = false;
  late PostProvider _postProvider;
  int? highlightedCommentId;
  void initial(){
    highlightedCommentId = null;
  }
  void setPostProvider(PostProvider postProvider) {
    _postProvider = postProvider;
  }

  void setComments (List<Comment> comments) => _comments = comments;
  List<Comment> parseComments(List<dynamic> data) {
    return data.map((item) => Comment.fromMap(item as Map<String, dynamic>)).toList();
  }

  Comment parseSingleComments(Map<String, dynamic> data) {
    return Comment.fromMap(data);
  }



  Comment? getComemnt(int id) {
    try {
      return _comments.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  highlightComment(int commentId){
    final index = _comments.indexWhere((p) => p.id == commentId);
   if (index != -1) {
    var item = _comments.removeAt(index);
    _comments.insert(0, item);
  }
  }
  addRepliesCount(int commentId){
    final index = _comments.indexWhere((p) => p.id == commentId);
    print(index);
    _comments[index].replies_count += 1;
    notifyListeners();
  }
  minusRepliesCount(int commentId){
    final index = _comments.indexWhere((p) => p.id == commentId);
    print(index);
    _comments[index].replies_count -= 1;
    notifyListeners();
  }
  List<Comment> get comments => _comments;
  Future<String?> likeComment(int commentId) async {
    final index = _comments.indexWhere((p) => p.id == commentId);
    // get the index of the post that has the postID from the _comments
    print(index);
    if (index == -1) {
      return "Comment not found";
    }
    _comments[index].is_liked =
        !_comments[index].is_liked; // if liked then change to false else true
    if (_comments[index].is_liked) {
      _comments[index].likes_count +=
          1; // if liked then increment else decrement
    } else {
      _comments[index].likes_count -=
          1; // if dis_liked then decrement else increment}
    }
    notifyListeners();
    try {
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/likes", data: {"id": commentId, "type": "comment"}),
      );
      if (result.status != true) {
        // re
        _comments[index].is_liked = !_comments[index].is_liked;
        if (_comments[index].is_liked) {
          _comments[index].likes_count += 1;
        } else {
          _comments[index].likes_count -= 1;
        }
        notifyListeners();
        return " error : ${result.message}";
      }
    } catch (e) {
      return ("error $e");
    }
  }

  Future<void> fetchComments(int postId) async {
    try {
      isLoading = true;
      notifyListeners();
      _comments.clear();
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/postComments", data: {"post_id": postId}),
      );
      if (result.status == true) {
        if (result.data is List) {
          List<dynamic> data = result.data as List<dynamic>;
          print("fetched ${data.length} comments");
          final List<Comment> fetchedComments = [];
          for (var item in data) {
            // loop post through the post list
            fetchedComments.add(
              Comment.fromMap(item as Map<String, dynamic>),
            ); // add each post to the post list
          }
         _comments.addAll(fetchedComments);
        if(highlightedCommentId != null){
        int index = _comments.indexWhere((comment)=>
           comment.id == highlightedCommentId
        );
        if(index != -1){
         Comment removedComment = _comments.removeAt(index);
          _comments.insert(0, removedComment);
        } 
        }
        } else {
          print("error not a list");
        }
      } else {
        print("error ${result.message}");
      }
    } catch (e) {
      print("error $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  addComments(int postId, String content, BuildContext context) async {
    try {
      isAddingComment = true;
      notifyListeners();
      ApiResult result = await Apihelper.post(
        ApiRequest(
          path: "/comment",
          data: {"post_id": postId, "content": content},
        ),
      );

      if (result.status == true) {
        Comment comment_data = parseSingleComments(result.data as Map<String, dynamic>);
        _comments.insert(0, comment_data);
        isAddingComment = false;
        notifyListeners();
        _postProvider.addCommentsCount(postId);
        return "success add comment";
      } else {
        return ("error ${result.message}");
      }
    } catch (e) {
      return("error $e");
    } 
  }

  Future<String> deleteComment(int id,int postId, BuildContext context) async {
    // id comment
    context.loaderOverlay.show(); // show the loader overlay
    try {
      ApiResult result = await Apihelper.delete(
        ApiRequest(path: "/comment/$id"),
      );
      print(result.message); // delete the comment
      if (result.status == true) {
        // optionally remove the deleted comment from list
        _comments.removeWhere((comment) => comment.id == id);
        _postProvider.minusCommentsCount(postId);

        return "Comment deleted successfully";
      } else {
        return ("Delete failed: ${result.message}");
      }
    } catch (e) {
      return ("error $e");
    }
    finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }

  Future<String?> editComment(
   {
    required int Id,
    required String content,
    required BuildContext context
    }
  ) async {
    try {
      context.loaderOverlay.show();
      ApiResult result = await Apihelper.patch(
        ApiRequest(path: "/comment/$Id", data: {"content": content}),
      );
      if (result.status == true) {
        final index = _comments.indexWhere((p) => p.id == Id);
        _comments[index].content = content;
        notifyListeners();
        return null;
      } else {
        return "error : ${result.message}";
      }
    } catch (e) {
      return ("error $e");
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
