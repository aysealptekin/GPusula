class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String categoryIcon;
  bool? isVibeMatch; // null: Bekliyor, true: Sağa, false: Sola

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryIcon,
    this.isVibeMatch,
  });
}
