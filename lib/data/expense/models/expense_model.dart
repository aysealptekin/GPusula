import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/expense/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.category,
    required super.type,
    required super.createdAt,
  });

  factory ExpenseModel.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    final createdAt = data['createdAt'];

    return ExpenseModel(
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
