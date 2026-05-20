class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String type;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.createdAt,
  });

  bool get isIncome => type == 'income';

  bool get isExpense => type == 'expense';
}
