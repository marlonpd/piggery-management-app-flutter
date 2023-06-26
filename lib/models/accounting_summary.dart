import 'dart:convert';

class AccountingSummary {
  double expensesSum = 0;
  double salesSum = 0;
  double netIncome = 0;

  AccountingSummary(
      {required this.expensesSum,
      required this.salesSum,
      required this.netIncome,});

  Map<String, dynamic> toMap() {
    return {
      'expenses_sum': expensesSum,
      'sales_sum': salesSum,
      'net_income': netIncome,
    };
  }

  AccountingSummary.fromMap(Map<String, dynamic> map) {
    expensesSum = map['expenses_sum'];
    salesSum = map['sales_sum'];
    netIncome = map['net_income'];
  }

  String toJson() => json.encode(toMap());

  factory AccountingSummary.fromJson(String source) => AccountingSummary.fromMap(json.decode(source));

  AccountingSummary copyWith({
    double? expensesSum,
    double? salesSum,
    double? netIncome,
  }) {
    return AccountingSummary(
      expensesSum: expensesSum ?? this.expensesSum,
      salesSum: salesSum ?? this.salesSum,
      netIncome: netIncome ?? this.netIncome,
    );
  }
}
