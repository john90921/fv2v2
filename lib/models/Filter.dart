// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fv2/models/Reply.dart';

class Filter {
  int? userId;
  String? date;
  String? sortBy;
  String? searhInput;
  Filter.initial({
    this.userId = null,
    this.date = "today",
    this.sortBy="popular",
    this.searhInput = null,
  });
  Filter.owner({
    required this.userId,
    required this.date,
    required this.sortBy,
    required this.searhInput,
  });
  Filter({
  this.userId,
   required this.date,
   required this.sortBy,
  this.searhInput,
  });


  void setDate(String date){
    this.date = date;
  }
  void setSortBy(String sortBy){
    this.sortBy = sortBy;
  }

  void setSearchInput(String searchInput){
    this.searhInput = searchInput;
  }
  

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
