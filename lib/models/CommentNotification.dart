// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class CommentNotification {
 final String id;
 final String type;
 final String title;
 final String message;
 final int comment_id;
 final int post_id;
final DateTime createdAt;
 final IconData icon = Icons.comment;
  bool is_read;

  CommentNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.comment_id,
    required this.post_id,
    required this.createdAt,
    required this.is_read,
  });
  



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'comment_id': comment_id,
      'post_id': post_id,
      'createdAt': createdAt,
      'is_read': is_read,
    };
  }

  factory CommentNotification.fromMap(Map<String, dynamic> map) {
    return CommentNotification(
      id: map['id'] ,
      type: map['type'] ?? '' ,
      title: map['title'] ?? '',
      message: map['message'] ?? "",
      comment_id: map['comment_id'] ?? "",
      post_id: map['post_id'] ?? "",
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
      is_read: map['is_read'] ?? false,
    );
  }
  String getTimeAgo() {
  Duration diff = DateTime.now().difference(createdAt);

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
  String toJson() => json.encode(toMap());

  factory CommentNotification.fromJson(String source) => CommentNotification.fromMap(json.decode(source) as Map<String, dynamic>);
}
