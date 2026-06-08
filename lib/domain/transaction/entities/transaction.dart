class TransactionEntity {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String type;
  final DateTime createdAt;
  final String vibeStatus;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.createdAt,
    this.vibeStatus = 'pending',
  });

  bool get isIncome => type == 'income';

  bool get isExpense => type == 'expense';

  bool get isVibePending => vibeStatus == 'pending';

  bool get isVibeMatch => vibeStatus == 'match';

  bool get isVibeMiss => vibeStatus == 'miss';
}
