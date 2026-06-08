import '../repositories/account_repository.dart';

class ClearTransactionHistoryUseCase {
  final AccountRepository repository;

  ClearTransactionHistoryUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.clearTransactionHistory(userId);
  }
}
