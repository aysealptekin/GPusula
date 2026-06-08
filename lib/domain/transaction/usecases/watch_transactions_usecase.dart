import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class WatchTransactionsUseCase {
  final TransactionRepository repository;

  WatchTransactionsUseCase(this.repository);

  Stream<List<TransactionEntity>> call(String userId) {
    return repository.watchTransactions(userId);
  }
}
