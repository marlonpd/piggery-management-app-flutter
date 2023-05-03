import 'dart:convert';

class Raise {
  String id = '';
  String raiseType = '';
  int headCount = 0;
  String name = '';
  String pigPen = '';

  Raise({required this.id, required this.raiseType, required this.headCount, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'raise_type': raiseType,
      'head_count': headCount,
      'pig_pen': pigPen,
    };
  }

  factory Raise.fromMap(Map<String, dynamic> map) {
    return Raise(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      raiseType: map['raise_type'] ?? '',
      headCount: map['head_count'] ?? 0,
      //  pigPen: map['pig_pen'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Raise.fromJson(String source) => Raise.fromMap(json.decode(source));

  Raise copyWith({
    String? id,
    String? name,
    String? raiseType,
    int? headCount,
  }) {
    return Raise(
      id: id ?? this.id,
      name: name ?? this.name,
      raiseType: raiseType ?? this.raiseType,
      headCount: headCount ?? this.headCount,
    );
  }
}
