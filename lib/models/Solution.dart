import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SolutionDetail {
  final String name;
  final String explanation;
  SolutionDetail({
    required this.name,
    required this.explanation,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'explanation': explanation,
    };
  }

  factory SolutionDetail.fromMap(Map<String, dynamic> map) {
    return SolutionDetail(
      name: map['name'] as String,
      explanation: map['explanation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SolutionDetail.fromJson(String source) => SolutionDetail.fromMap(json.decode(source) as Map<String, dynamic>);
}
