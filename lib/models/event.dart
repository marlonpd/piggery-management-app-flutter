import 'dart:convert';

class Event {
  String id = '';
  String raiseId = '';
  String eventDate = '';
  String title = '';
  String createdAt = '';
  String updatedAt = '';

  Event(
      {required this.id,
      required this.raiseId,
      required this.eventDate,
      required this.title,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'raise_id': raiseId,
      'title': title,
      'event_date': eventDate,
      'create_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['_id'] ?? '',
      raiseId: map['raise_id'] ?? '',
      title: map['title'] ?? '',
      eventDate: map['event_date'] ?? '',
      createdAt: map['created_at'] ?? 0,
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));

  Event copyWith({
    String? id,
    String? raiseId,
    String? title,
    String? eventDate,
    String? createdAt,
    String? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      raiseId: raiseId ?? this.raiseId,
      title: title ?? this.title,
      eventDate: eventDate ?? this.eventDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
