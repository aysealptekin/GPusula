import '../entities/transaction.dart';

abstract class TransactionRepository {
  Stream<List<TransactionEntity>> watchTransactions(String userId);

  Future<void> addTransaction({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required String type,
  });

  Future<void> updateTransaction({
    required String userId,
    required String transactionId,
    required String title,
    required double amount,
    required String category,
    required String type,
  });

  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  });

  Future<void> updateVibeStatus({
    required String userId,
    required String transactionId,
    required String vibeStatus,
  });
}
