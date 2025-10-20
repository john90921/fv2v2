// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fv2/models/Reply.dart';

class Comment extends ChangeNotifier {
  // Add your comment model properties and methods here
  final int id;
  final int post_id;
  final int owner_id;
  String content;
  final DateTime created_at;
  DateTime updated_at;
  bool is_liked;
  int likes_count;
  int replies_count;
  final String? owner_name;
  final String? owner_image;
  bool showReplyButton = false;

  
  Comment({
    required this.id,
    required this.post_id,
    required this.content,
    required this.created_at,
    required this.updated_at,
    required this.is_liked,
    required this.likes_count,
    required this.owner_id,
    required this.owner_name,
    required this.owner_image,
    required this.replies_count
  });


  

 
 
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

  // static Comment exampleComment() {
  //   return Comment(
  //     content: "This is a comment.",
  //     created_at: DateTime.now().subtract(Duration(minutes: 5)),
  //     updated_at: DateTime.now().subtract(Duration(minutes: 3)),
  //     owner: "Jane Smith",
  //     ownerImage: "https://example.com/jane_smith.jpg",
  //     isLiked: false,
  //     likes: 10,
  //     numberOfReplies: 2,
  //     replies: [
  //       Reply(
  //         content: "This is a reply.",
  //         created_at: DateTime.now().subtract(Duration(minutes: 2)),
  //         updated_at: DateTime.now().subtract(Duration(minutes: 1)),
  //         owner: "John Doe",
  //         ownerImage: "https://example.com/john_doe.jpg",
  //         isLiked: true,
  //         likes: 5,
  //       ),
  //       Reply(
  //         content: "This is another reply.",
  //         created_at: DateTime.now().subtract(Duration(minutes: 1)),
  //         updated_at: DateTime.now(),
  //         owner: "Jane Smith",
  //         ownerImage: "https://example.com/jane_smith.jpg",
  //         isLiked: false,
  //         likes: 3,
  //       ),
  //     ],
  //   );
  // }
  // List<Comment> example(){
  //   return [
  //     Comment(
  //       content: "This is a comment.",
  //       created_at: DateTime.now().subtract(Duration(minutes: 5)),
  //       updated_at: DateTime.now().subtract(Duration(minutes: 3)),
  //       owner: "Jane Smith",
  //       ownerImage: "https://example.com/jane_smith.jpg",
  //       isLiked: false,
  //       likes: 10,
  //       numberOfReplies: 2,
  //       replies: [
  //         Reply(
  //           content: "This is a reply.",
  //           created_at: DateTime.now().subtract(Duration(minutes: 2)),
  //           updated_at: DateTime.now().subtract(Duration(minutes: 1)),
  //           owner: "John Doe",
  //           ownerImage: "https://example.com/john_doe.jpg",
  //           isLiked: true,
  //           likes: 5,
  //         ),
  //         Reply(
  //           content: "This is another reply.",
  //           created_at: DateTime.now().subtract(Duration(minutes: 1)),
  //           updated_at: DateTime.now(),
  //           owner: "Jane Smith",
  //           ownerImage: "https://example.com/jane_smith.jpg",
  //           isLiked: false,
  //           likes: 3,
  //         ),
  //       ],
  //     ),
  //     Comment(
  //       content: "This is another comment.",
  //       created_at: DateTime.now().subtract(Duration(hours: 1)),
  //       updated_at: DateTime.now().subtract(Duration(minutes: 50)),
  //       owner: "John Doe",
  //       ownerImage: "https://example.com/john_doe.jpg",
  //       isLiked: true,
  //       likes: 5,
  //       numberOfReplies: 0,
  //       replies: [],
  //     ),
  //     Comment(
  //       content: "This is yet another comment.",
  //       created_at: DateTime.now().subtract(Duration(days: 1)),
  //       updated_at: DateTime.now().subtract(Duration(hours: 20)),
  //       owner: "Alice Johnson",
  //       ownerImage: "https://example.com/alice_johnson.jpg",
  //       isLiked: false,
  //       likes: 3,
  //       numberOfReplies: 1,
  //       replies: [],
  //     )
  //   ];
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'post_id': post_id,
      'content': content,
      'created_at': created_at.toUtc().toIso8601String(),
      'updated_at': updated_at.toUtc().toIso8601String(),
      'is_liked': is_liked,
      'likes_count': likes_count,
      'owner_name': owner_name,
      'owner_image': owner_image,
      'replies_count': replies_count
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int,
      post_id: map['post_id'] as int,
      owner_id: map['owner_id'] ?? 0,
      content: map['content'] as String,
      created_at: DateTime.parse(map['created_at'] as String).toLocal(),
      updated_at: DateTime.parse(map['updated_at'] as String).toLocal(),
      is_liked: map['is_liked'] as bool,
      likes_count: map['likes_count'] as int,
      replies_count : map['replies_count'] ?? 0,
      owner_name: map['owner_name'] ?? "",
      owner_image: map['owner_image'] ?? "",
    );
  }

  // String toJson() => json.encode(toMap());

  // factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source) as Map<String, dynamic>);
}
