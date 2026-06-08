import '../repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String transactionId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) {
    return repository.updateTransaction(
      userId: userId,
      transactionId: transactionId,
      title: title,
      amount: amount,
      category: category,
      type: type,
    );
  }
}
