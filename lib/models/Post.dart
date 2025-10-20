// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fv2/models/Comment.dart';
import 'package:fv2/models/Reply.dart';

class Post extends ChangeNotifier {
  final int id;
  String title;
  String content;
  String? image;
  final DateTime created_at;
  final DateTime updated_at;
  bool isLiked;
  int likesCount;
  int commentsCount;
  final String ownerName;
  final String? ownerImage;
  List<Comment>? comments;


  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.created_at,
    required this.updated_at,
    required this.isLiked,
    required this.likesCount,
    required this.commentsCount,
    required this.ownerName,
    required this.ownerImage,
  });

  //  Post.postList({
  //   required this.id,
  //   required this.title,
  //   required this.content,
  //   required this.image,
  //   required this.created_at,
  //   required this.updated_at,
  //   required this.ownerName,
  //   required this.ownerImage,
  // });
  // void addComment(String text){
  //   this.comments!.insert(0,
  //     Comment(
  //       content: text,
  //       created_at: DateTime.now().subtract(Duration(hours: 1)),
  //       updated_at: DateTime.now().subtract(Duration(minutes: 50)),
  //       owner: "John Doe",
  //       ownerImage: "https://example.com/john_doe.jpg",
  //       isLiked: true,
  //       likes: 5,
  //       numberOfReplies: 0,
  //       replies: [],
  //     ),
  //   );
  //   notifyListeners();
  // }
  bool hasComment(){
    return comments != null && comments!.isNotEmpty;
  }

  String getTimeAgo() {
  Duration diff = DateTime.now().difference(created_at);

    if (diff.inDays > 0) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "just now";
    }
  }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'image': image,
      'created_at': created_at.toUtc().toIso8601String(),
      'updated_at': updated_at.toUtc().toIso8601String(),
      'owner': ownerName,
      'ownerImage': ownerImage,
      'comments': comments != null ? comments!.map((x) => x.toMap()).toList() : [],
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      image: map['image'] as String?,
      created_at: DateTime.parse(map['created_at'] as String).toLocal(),
      updated_at: DateTime.parse(map['updated_at'] as String).toLocal(),
      isLiked: map['is_liked'] ?? false,
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      ownerName: map['owner_name'] ?? 'no name',
      ownerImage: map['owner_image'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source) as Map<String, dynamic>);

}
 

    