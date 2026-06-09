import '../repositories/transaction_repository.dart';

class ResetVibeStatusesUseCase {
  final TransactionRepository repository;

  ResetVibeStatusesUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.resetVibeStatuses(userId);
  }
}
