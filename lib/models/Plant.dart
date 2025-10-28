// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:flutter/material.dart';

class Plant {
final int id;
 final String name;
 final String image;
  final DateTime created_at;


  Plant({
    required this.id,
    required this.name,
    required this.image,
    required this.created_at,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': image,
      'created_at': created_at.toUtc().toIso8601String(),
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      created_at: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Plant.fromJson(String source) => Plant.fromMap(json.decode(source) as Map<String, dynamic>);
}
