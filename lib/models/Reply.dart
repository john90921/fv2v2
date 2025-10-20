// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Reply extends ChangeNotifier {
  // final Comment? comment;
  final int id;
  final int owner_id;
  final int taged_user_id;
  final int comment_id;
   String content;
  final DateTime created_at;
  final DateTime updated_at;
  bool isLiked;
  int likes_count;
  final String owner_name;
  final String? owner_image;
  final String? taged_name;
  final String? taged_image;

  Reply({
    // this.comment,
    required this.id,
    required this.owner_id,
    required this.taged_user_id,
    required this.comment_id,
    required this.content,
    required this.created_at,
    required this.updated_at,
    required this.isLiked,
    required this.likes_count,
    required this.owner_name,
    required this.owner_image,
    required this.taged_name,
    required this.taged_image,
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'owner_id': owner_id,
      'taged_user_id': taged_user_id,
      'comment_id': comment_id,
      'content': content,
      'created_at': created_at.millisecondsSinceEpoch,
      'updated_at': updated_at.millisecondsSinceEpoch,
      'isLiked': isLiked,
      'likes_count': likes_count,
      'owner_name': owner_name,
      'owner_image': owner_image,
      'taged_name': taged_name,
      'taged_image': taged_image,
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      id: map['id'] as int,
      owner_id: map['owner_id'] as int,
      taged_user_id: map['taged_user_id'] as int,
      comment_id: map['comment_id'] as int,
      content: map['content'] as String,
      created_at: DateTime.parse(map['created_at'] as String).toLocal(),
      updated_at: DateTime.parse(map['updated_at'] as String).toLocal(),
      isLiked: map['is_liked'] as bool,
      likes_count: map['likes_count'] as int,
      owner_name: map['owner_name'] ?? "no name",
      owner_image: null,
      taged_name: map['taged_name'] ?? "no name",
      taged_image: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reply.fromJson(String source) =>
      Reply.fromMap(json.decode(source) as Map<String, dynamic>);
}
