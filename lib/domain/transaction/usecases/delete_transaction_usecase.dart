import '../repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<void> call({required String userId, required String transactionId}) {
    return repository.deleteTransaction(
      userId: userId,
      transactionId: transactionId,
    );
  }
}
