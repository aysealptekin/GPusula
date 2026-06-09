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
    return _transactionsRef(
      userId,
    ).doc(transactionId).update({'vibeStatus': vibeStatus});
  }

  Future<void> resetVibeStatuses(String userId) async {
    final snapshot = await _transactionsRef(userId).get();
    final batches = <WriteBatch>[];
    var batch = firestore.batch();
    var operationCount = 0;

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'vibeStatus': 'pending'});
      operationCount++;

      if (operationCount == 450) {
        batches.add(batch);
        batch = firestore.batch();
        operationCount = 0;
      }
    }

    if (operationCount > 0) {
      batches.add(batch);
    }

    for (final batch in batches) {
      await batch.commit();
    }
  }

  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) {
    return _transactionsRef(userId).doc(transactionId).delete();
  }
}
