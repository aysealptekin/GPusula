import '../repositories/transaction_repository.dart';

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required String type,
  }) {
    return repository.addTransaction(
      userId: userId,
      title: title,
      amount: amount,
      category: category,
      type: type,
    );
  }
}
