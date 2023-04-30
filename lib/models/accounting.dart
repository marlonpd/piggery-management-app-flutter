class Accounting {
  String id = '';
  String raiseId = '';
  String description = '';
  String entryType = '';
  double amount = 0;
  String createdAt = '';
  String updatedAt = '';
 
  Accounting(this.id, this.raiseId, this.description, this.entryType, this.amount, this.createdAt, this.updatedAt);

  Accounting.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.raiseId = map['raise_id'];
    this.description = map['description'];
    this.entryType = map['entry_type'];
    this.amount = double.parse(map['amount']);
    this.createdAt = map['created_at'];
    this.updatedAt = map['updated_at'];
  }
}