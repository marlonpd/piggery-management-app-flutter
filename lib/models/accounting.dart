import 'dart:convert';

class Accounting {
  String id = '';
  String raiseId = '';
  String description = '';
  String entryType = '';
  double amount = 0;
  String createdAt = '';
  String updatedAt = '';

  Accounting(
      {required this.id,
      required this.raiseId,
      required this.description,
      required this.entryType,
      required this.amount,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'raise_id': raiseId,
      'title': description,
      'entry_type': entryType,
      'amount': amount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Accounting.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    raiseId = map['raise_id'];
    description = map['description'];
    entryType = map['entry_type'];
    amount = double.parse(map['amount']);
    createdAt = map['created_at'];
    updatedAt = map['updated_at'];
  }

  String toJson() => json.encode(toMap());

  factory Accounting.fromJson(String source) => Accounting.fromMap(json.decode(source));

  Accounting copyWith({
    String? id,
    String? raiseId,
    String? entryType,
    String? description,
    double? amount,
    String? createdAt,
    String? updatedAt,
  }) {
    return Accounting(
      id: id ?? this.id,
      raiseId: raiseId ?? this.raiseId,
      entryType: entryType ?? this.entryType,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
