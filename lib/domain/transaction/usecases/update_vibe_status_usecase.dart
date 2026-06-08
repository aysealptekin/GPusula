import '../repositories/transaction_repository.dart';

class UpdateVibeStatusUseCase {
  final TransactionRepository repository;

  UpdateVibeStatusUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String transactionId,
    required String vibeStatus,
  }) {
    return repository.updateVibeStatus(
      userId: userId,
      transactionId: transactionId,
      vibeStatus: vibeStatus,
    );
  }
}
