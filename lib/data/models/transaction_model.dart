import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String type;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.createdAt,
  });

  bool get isIncome => type == 'income';

  bool get isExpense => type == 'expense';

  factory TransactionModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    final createdAt = data['createdAt'];

    return TransactionModel(
      id: document.id,
      title: data['title'] ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      category: data['category'] ?? '',
      type: data['type'] ?? 'expense',
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
