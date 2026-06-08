import '../../../domain/transaction/entities/transaction.dart';
import '../../../domain/transaction/repositories/transaction_repository.dart';
import '../../services/transaction_service.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionService transactionService;

  TransactionRepositoryImpl(this.transactionService);

  @override
  Stream<List<TransactionEntity>> watchTransactions(String userId) {
    return transactionService.watchTransactions(userId);
  }

  @override
  Future<void> addTransaction({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) {
    return transactionService.addTransaction(
      userId: userId,
      title: title,
      amount: amount,
      category: category,
      type: type,
    );
  }

  @override
  Future<void> updateTransaction({
    required String userId,
    required String transactionId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) {
    return transactionService.updateTransaction(
      userId: userId,
      transactionId: transactionId,
      title: title,
      amount: amount,
      category: category,
      type: type,
    );
  }

  @override
  Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) {
    return transactionService.deleteTransaction(
      userId: userId,
      transactionId: transactionId,
    );
  }

  @override
  Future<void> updateVibeStatus({
    required String userId,
    required String transactionId,
    required String vibeStatus,
  }) {
    return transactionService.updateVibeStatus(
      userId: userId,
      transactionId: transactionId,
      vibeStatus: vibeStatus,
    );
  }
}
