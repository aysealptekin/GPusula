import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore firestore;

  TransactionService({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _transactionsRef(String userId) {
    return firestore.collection('users').doc(userId).collection('expenses');
  }

  Stream<List<TransactionModel>> watchTransactions(String userId) {
    return _transactionsRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(TransactionModel.fromFirestore).toList(),
        );
  }

  Future<void> addTransaction({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) {
    final transaction = TransactionModel(
      id: '',
      title: title,
      amount: amount,
      category: category,
      type: type,
      createdAt: DateTime.now(),
    );

    return _transactionsRef(userId).add(transaction.toFirestore());
  }

  Future<void> updateTransaction({
    required String userId,
    required String transactionId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) {
    return _transactionsRef(userId).doc(transactionId).update({
      'title': title,
      'amount': amount,
      'category': category,
      'type': type,
    });
  }

  Future<void> updateVibeStatus({
    required String userId,
    required String transactionId,
    required String vibeStatus,
  }) {
    return _transactionsRef(userId).doc(transactionId).update({
      'vibeStatus': vibeStatus,
    });
  }

  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) {
    return _transactionsRef(userId).doc(transactionId).delete();
  }
}
