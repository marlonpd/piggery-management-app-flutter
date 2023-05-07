import 'dart:convert';

class Note {
  String id = '';
  String raiseId = '';
  String title = '';
  String description = '';
  String createdAt = '';
  String updatedAt = '';

  Note(
      {required this.id,
      required this.raiseId,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'raise_id': raiseId,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['_id'] ?? '',
      raiseId: map['raise_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['created_at'] ?? 0,
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  Note copyWith({
    String? id,
    String? raiseId,
    String? title,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      raiseId: raiseId ?? this.raiseId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
