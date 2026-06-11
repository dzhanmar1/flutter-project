class FinanceTransaction {
  final int? id;
  final double amount;
  final int categoryId;
  final String date;
  final String? note;

  FinanceTransaction({
    this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category_id': categoryId,
      'date': date,
      'note': note,
    };
  }

  factory FinanceTransaction.fromMap(Map<String, dynamic> map) {
    return FinanceTransaction(
      id: map['id'],
      amount: map['amount'],
      categoryId: map['category_id'],
      date: map['date'],
      note: map['note'],
    );
  }
}
