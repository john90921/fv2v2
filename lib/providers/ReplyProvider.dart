import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/Reply.dart';
import 'package:fv2/providers/CommentProvider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class ReplyProvider extends ChangeNotifier {
  List<Reply> _replies = [];
  bool isLoading = false;
  int pages =1;
  bool hasMore = true;
  //   bool isAddingComment = false;

  List<Reply> get replies => _replies;
  Reply getReply(int id) => _replies.firstWhere((reply) => reply.id == id);

  void setReplies(List<Reply> replies) {
    _replies = replies;
  }

  Reply parseSingleReply(Map<String, dynamic> data) {
    return Reply.fromMap(data);
  }

  List<Reply> parseReplies(List<dynamic> data) {
    return data
        .map((item) => Reply.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  LoadMoreRepliesData(int comment_id) async {
    try {
      pages++;
      notifyListeners();
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/commentReplies", data: {"comment_id": comment_id}),
      );
      if (result.status == true) {
        if (result.data is List) {
          List<dynamic> data = result.data as List<dynamic>;

          _replies.addAll(parseReplies(data));
          isLoading = false;
          notifyListeners();
          return ("success ${replies.length} replies");
        } else {
          return ("error not a list");
        }
      } else {
        return ("error ${result.message}");
      }
    } catch (e) {
      return ("error $e");
    }
  }

  Future<String?> fetchReplies(int comment_id) async {
    try {
      isLoading = true;
      notifyListeners();
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/commentReplies", data: {"comment_id": comment_id}),
      );
      if (result.status == true) {
        if (result.data is List) {
          List<dynamic> data = result.data as List<dynamic>;

          _replies
            ..clear()
            ..addAll(parseReplies(data));
          isLoading = false;
          notifyListeners();
          return ("success ${replies.length} replies");
        } else {
          return ("error not a list");
        }
      } else {
        return ("error ${result.message}");
      }
    } catch (e) {
      return ("error $e");
    }
  }

  Future<String?> addReply({
    required int taged_user_id,
    required int comment_id,
    required String content,
    required BuildContext context,
  }) async {
    context.loaderOverlay.show();
    try {
      ApiResult result = await Apihelper.post(
        ApiRequest(
          path: "/reply",
          data: {
            "taged_user_id": taged_user_id,
            "comment_id": comment_id,
            "content": content,
          },
        ),
      );
      if (result.status == true) {
        Reply reply = parseSingleReply(result.data as Map<String, dynamic>);
        _replies.add(reply);
        Provider.of<CommentProvider>(
          context,
          listen: false,
        ).addRepliesCount(comment_id);
        notifyListeners();

        return ("success");
      } else {
        return ("error ${result.message}");
      }
    } catch (e) {
      return ("error $e");
    }finally {
      context.loaderOverlay.hide();
    }
  }

  Future<String?> likeReply(int replyId) async {
    final index = _replies.indexWhere((p) => p.id == replyId);
    // get the index of the post that has the postID from the _comments
    print(index);
    if (index == -1) {
      return "reply not found";
    }
    _replies[index].isLiked =
        !_replies[index].isLiked; // if liked then change to false else true
    if (_replies[index].isLiked) {
      _replies[index].likes_count +=
          1; // if liked then increment else decrement
    } else {
      _replies[index].likes_count -=
          1; // if dis_liked then decrement else increment}
    }
    notifyListeners();
    try {
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/likes", data: {"id": replyId, "type": "reply"}),
      );
      if (result.status != true) {
        // re
        _replies[index].isLiked = !_replies[index].isLiked;
        if (_replies[index].isLiked) {
          _replies[index].likes_count += 1;
        } else {
          _replies[index].likes_count -= 1;
        }
        notifyListeners();
        return " error : ${result.message}";
      }
    } catch (e) {
      return ("error $e");
    }
  }

  Future<String> deleteReply(
    int id,
    int commentId,
    BuildContext context,
  ) async {
    // id comment
    context.loaderOverlay.show(); // show the loader overlay
    try {
      ApiResult result = await Apihelper.delete(ApiRequest(path: "/reply/$id"));
      print(result.message); // delete the comment
      if (result.status == true) {
        // optionally remove the deleted comment from list
        _replies.removeWhere((reply) => reply.id == id);
        context.read<CommentProvider>().minusRepliesCount(commentId);

        return "Rely deleted successfully";
      } else {
        return ("Delete failed: ${result.message}");
      }
    } catch (e) {
      return ("error $e");
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }

  Future<String?> editReply(
   {
    required int replyId,
    required String content,
    required BuildContext context
    }
  ) async {
    try {
      context.loaderOverlay.show();
      ApiResult result = await Apihelper.patch(
        ApiRequest(path: "/reply/$replyId", data: {"content": content}),
      );
      if (result.status == true) {
        final index = _replies.indexWhere((p) => p.id == replyId);
        if (index != -1) {
          _replies[index].content = content;
        }
    
        return "Reply updated successfully";
      } else {
        return "Update failed: ${result.message}";
      }
    } catch (e) {
      return ("error $e");
    }
    finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }
}
