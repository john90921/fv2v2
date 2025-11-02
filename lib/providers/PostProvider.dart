import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/Filter.dart';
import 'package:fv2/models/Post.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:isolate';
import 'dart:convert';

class PostProvider extends ChangeNotifier {
  
  bool isLoading = false;
  bool success = false;
  List<Post> _postList = [];
  bool isLoadingMore = false;
  List<Post> get postList => _postList;
  Post? _selectedPost;
  Filter? _currentFilter = Filter.initial();
  bool _disposed = false;

  int pages = 1;
  bool hasMore = true;
  void setCurrentFilter(Filter? filter){
    _currentFilter = filter;
  }
  Filter? get currentFilter => _currentFilter;
    @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void setPostList(List<Post> value) {
    _postList = value;
  }

  void initialHomePage(){
     hasMore= true;
    _currentFilter = Filter(
      userId: null,
      date: "week",
      sortBy: "popular",
      searhInput: null,
    ); // reset filter to initial values
    _selectedPost = null; 
  }

  void initial() {
    hasMore= true;
    _currentFilter = Filter.initial(); // reset filter to initial values
    _selectedPost = null; //initialSelectedPost  // for certain posr page
  }

  Future<String?> likePost(int postId) async {
    final Post? updatedPost;

    if (_selectedPost != null) {
      _selectedPost = _selectedPost!.copyWith(
        isLiked: !_selectedPost!.isLiked,
        likesCount: _selectedPost!.isLiked
            ? _selectedPost!.likesCount - 1
            : _selectedPost!.likesCount + 1,
      );
      // _selectedPost = updatedPost;
      notifyListeners();
    } else {
      final index = _postList.indexWhere((p) => p.id == postId);
      // get the index of the post that has the postID from the postList

      if (index == -1) {
        return "Post not found";
      }
      _postList[index] = _postList[index].copyWith(
        isLiked: !_postList[index].isLiked,
        likesCount: _postList[index].isLiked
            ? _postList[index].likesCount - 1
            : _postList[index].likesCount + 1,
      );
      notifyListeners();
      print("post liked: ${_postList[index].isLiked}");
    }

    try {
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/likes", data: {"id": postId, "type": "post"}),
      );
      if (result.status != true) {

        
        return " error";
      }
    } catch (e) {
      return ("error");
    }
  }

  addCommentsCount(int postId) {
    if (_selectedPost != null && _selectedPost!.id == postId) {
      _selectedPost = _selectedPost!.copyWith(
        commentsCount: _selectedPost!.commentsCount += 1,
      );
    } else {
      final index = postList.indexWhere((p) => p.id == postId);
      if (index != -1) {
        postList[index] = postList[index].copyWith(
          commentsCount: postList[index].commentsCount += 1,
        );
      }
    }
    notifyListeners();
  }

  minusCommentsCount(int postId) {
    if (_selectedPost != null && _selectedPost!.id == postId) {
      _selectedPost = _selectedPost!.copyWith(
        commentsCount: _selectedPost!.commentsCount -= 1,
      );
    } else {
      final index = postList.indexWhere((p) => p.id == postId);
      if (index != -1) {
        postList[index] = postList[index].copyWith(
          commentsCount: postList[index].commentsCount -= 1,
        );
      }
    }
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
    String? state,
    String? city,
  ) async {
    bool success = false;
    try {
      // Show loading overlay
      print("image path: ${imagePath}");
      // Create form data for Dio
      FormData formData = FormData.fromMap({
        'title': title,
        'content': content,
        if (imagePath != null)
          'image': imagePath,
        if (state != null)
         'state': state,
        if (city != null)
          'city': city,
      });
      print("form data: $formData");
      print("Sending new post to API ... ${formData}");

      // Send POST request
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/post", data: formData),
      );

      if (result.status == true) {
        Map<String, dynamic> data = result.data as Map<String, dynamic>;

        print(data);
        Post post = Post.fromMap(data);
        postList.insert(0, post);
        //get the post list data as a list
        // Example: refresh posts or show a success message

        // Optionally refresh UI
        notifyListeners();
        success = true;
        
      } else {
        print("error ${result.message}");
      }
    } catch (e) {
      print("error $e");
    }
    if(success == true){
    return "success added post";
    }
    else{
      return "error adding post";
    }

  }

  Future<String?> editPost({
    required Post post,
    required String title,
    required String content,
    required bool isRemoveImage,
    required bool HaveUploadedImage,
    required String? newImagePath,
  }) async {
    print("edit post");
    try {
      FormData formData;

      formData = FormData.fromMap({
        // if new image selected or delered image before, then send image field
        'title': title,
        'content': content,
        '_method': 'PATCH',
        if (isRemoveImage == true && HaveUploadedImage == true)
          'remove_image': true,
        if (newImagePath != null)
          'image': 
            newImagePath,
//new image selected
      });

      ApiResult result = await Apihelper.patch(
        ApiRequest(path: "/post/${post.id}", data: formData),
      );
      if (result.status == true) {
        print(result.data);
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        print("update ${result.data}");
        Post updatedPost = Post.fromMap(data);
        if (_selectedPost != null && _selectedPost!.id == post.id) {
          _selectedPost = updatedPost;
        } else {
          final index = postList.indexWhere((p) => p.id == post.id);
          if (index != -1) {
            postList[index] = updatedPost;
            notifyListeners();
          }
        }
        return ("success edited post");
      } else {
        print("error ${result.message}");
      }
    } on Exception catch (e) {
      // TODO
      print("error $e");
    }
  }
 Future<String> reportPost(int id, BuildContext context) async {
    // id post
  // show the loader overlay
    try {
      context.loaderOverlay.show();

      ApiResult result = await Apihelper.post(
        ApiRequest(path: "report", data: {"id": id,"type":"post", "reason": "spam"}),
      ); // delete the post

        // optionally remove the deleted post from list
        if (_selectedPost != null && _selectedPost!.id == id) {
          _selectedPost = null;
        }

        final index = postList.indexWhere((p) => p.id == id);
        if (index != -1) {
            postList.removeAt(index);
        }


        
        notifyListeners();
        return "Post reported successfully";
      
    } catch (e) {
      return ("error");
    }
    finally{
      context.loaderOverlay.hide();
    }
    
  }
  Future<String> deletePost(int id, BuildContext context) async {
    // id post
    try {
      context.loaderOverlay.show();
      ApiResult result = await Apihelper.delete(
        ApiRequest(path: "/post/$id"),
      ); // delete the post
      if (result.status == true) {
        success = true;
        // optionally remove the deleted post from list
        if (_selectedPost != null && _selectedPost!.id == id) {
          _selectedPost = null;
        }

        final index = postList.indexWhere((p) => p.id == id);
          if (index != -1) {
            postList.removeAt(index);
          }


        notifyListeners();
        return "Post deleted successfully";
      } else {
        return ("Delete failed");
      }
    } catch (e) {
      return ("error");
    }finally{
      context.loaderOverlay.hide();
    }
  }

  List<Post> parsePosts(List<dynamic> data) {
    return data
        .map((item) => Post.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  void applySearch(String searchInput){
    _currentFilter?.searhInput = searchInput;
    getTodayPostsDataTesting().catchError((e) {
      print("error $e");
    });
  }


  LoadMoreTodayPostsData() async {
  print("load _currentFilter.date: ${_currentFilter?.date}, _currentFilter.sortBy: ${_currentFilter?.sortBy}, _currentFilter?.searhInput: ${_currentFilter?.searhInput}");

    try {
      if (isLoadingMore || !hasMore) return;
      pages++;
      hasMore = true;
      isLoadingMore = true;
      Filter filter = Filter(date: _currentFilter?.date, sortBy: _currentFilter?.sortBy, searhInput: _currentFilter?.searhInput, userId: _currentFilter?.userId);
      String date = filter.date ?? "today";
      String sortBy = filter.sortBy ?? "popular";
      String searchInput = filter.searhInput ?? "";
      int? userId = filter.userId;
      ApiResult result = await Apihelper.get(
        ApiRequest(path: "/communityPosts",
        data: {
          'page': pages,
          'date': date,
          'sortBy': sortBy,
          if(searchInput != "" && searchInput != null) 
          'searchInput': searchInput,
          if(userId != null)
          'userId': userId,
        }),
      );
      if (result.data is List) {
        // check if data is a list
        List<dynamic> data =
            result.data as List<dynamic>; //get the post list data as a list
        List<Post> posts = parsePosts(data);
        if (posts.isEmpty) {
          hasMore = false;
        } else {
          _postList.addAll(posts);
        }
      } else {
        print("no list data"); // if data is not a list
      }
    } catch (e) {
      print("error $e");
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // getTodayPostsDataTest() async {
  //   try {
  //     pages = 1;
  //     isLoading = true;
  //     postList.clear();
  //     notifyListeners(); // Notify listeners that data is loading
  //     final posts = await compute(fetchTodayPostsInIsolate, "/todayPosts");

  //     setPostList(posts); // set the post list with the parsed post list

  //     print(postList.length);
  //   } catch (e) {
  //     print("error $e"); // handle errors
  //   } finally {
  //     isLoading = false;
  //     notifyListeners(); // Notify listeners that data is loaded
  //   }
  // }dolo
 getTodayPostsDataTesting() async {
  print("_currentFilter.date: ${_currentFilter?.date}, _currentFilter.sortBy: ${_currentFilter?.sortBy}, _currentFilter?.searhInput: ${_currentFilter?.searhInput}");
    try {
      pages = 1;
      isLoading = true;
      postList.clear();
      notifyListeners(); // Notify listeners that data is loading
      Filter filter = Filter(date: _currentFilter?.date, sortBy: _currentFilter?.sortBy, searhInput: _currentFilter?.searhInput, userId: _currentFilter?.userId);
      String date = filter.date ?? "today";
      String sortBy = filter.sortBy ?? "popular";
      String searchInput = filter.searhInput ?? "";
      int? userId = filter.userId;
      ApiResult result = await Apihelper.get(ApiRequest(path: "/communityPosts",
     
      data: {
          'date': date,
          'sortBy': sortBy,
          if(searchInput != "" && searchInput != null) 
          'searchInput': searchInput,
          if(userId != null)
          'userId': userId,
        }
      )
      
      );

      if (result.status) {
        // check if data is a list
        List<dynamic> data =
            result.data as List<dynamic>; //get the post list data as a list
        List<Post> posts = [];
        for (var item in data) {
          // loop post through the post list
          posts.add(
            Post.fromMap(item as Map<String, dynamic>),
          ); // add each post to the post list
        }
        setPostList(posts);
 // set the post list with the parsed post list
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

  getTodayPostsData() async {
    try {
      pages = 1;
      isLoading = true;
      postList.clear();
      notifyListeners(); // Notify listeners that data is loading
      ApiResult result = await Apihelper.get(ApiRequest(path: "/communityPosts"));
      if (result.data is List) {
        // check if data is a list
        List<dynamic> data =
            result.data as List<dynamic>; //get the post list data as a list
        List<Post> posts = [];
        for (var item in data) {
          // loop post through the post list
          posts.add(
            Post.fromMap(item as Map<String, dynamic>),
          ); // add each post to the post list
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

  Post? getPost(int id) {
    if (_selectedPost != null && _selectedPost!.id == id) {
      return _selectedPost;
    }
    try {
      return _postList.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  fetchPostByID(int postId) async {
    try {
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/retrievePostById", data: {"post_id": postId}),
      );
      print(result.message);
      if (result.status == true) {
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        _selectedPost = Post.fromMap(data);
      } else {
        print("Failed to load post: ${result.message}");
        return null;
      }
    } on Exception catch (e) {
      print("error $e");
      return null;
    }
  }
}

// Function that runs in isolate
Future<List<Post>> fetchTodayPostsInIsolate(String path) async {
  ApiResult result = await Apihelper.get(ApiRequest(path: path));

  if (result.data is List) {
    final List data = result.data as List;
    return data.map((e) => Post.fromMap(e as Map<String, dynamic>)).toList();
  } else {
    return [];
  }
}
