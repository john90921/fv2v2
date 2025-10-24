// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fv2/models/Reply.dart';

class Filter {
  String? date;
  String? sortBy;
  String? searhInput;
  Filter.initial({
    this.date = "today",
    this.sortBy="latest",
    this.searhInput = "",
  });
  Filter({
    this.date,
    this.sortBy,
    this.searhInput,
  });
  
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'sortBy': sortBy,
      'searhInput': searhInput,
    };
  }

  factory Filter.fromMap(Map<String, dynamic> map) {
    return Filter(
      date: map['date'] != null ? map['date'] as String : null,
      sortBy: map['SortBy'] != null ? map['SortBy'] as String : null,
      searhInput: map['searhInput'] != null ? map['searhInput'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Filter.fromJson(String source) => Filter.fromMap(json.decode(source) as Map<String, dynamic>);
}
