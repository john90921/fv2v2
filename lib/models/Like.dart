import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fv2/models/Reply.dart';

class Like extends ChangeNotifier {
  final int id;
  final String stype;

  Like({
    required this.id,
    required this.stype,
  });

  
}