import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/transaction/entities/transaction.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.category,
    required super.type,
    required super.createdAt,
    super.vibeStatus,
  });

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
      vibeStatus: data['vibeStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'vibeStatus': vibeStatus,
    };
  }
}
