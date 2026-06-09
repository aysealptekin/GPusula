import '../repositories/account_repository.dart';

class UpdateVibeScheduleUseCase {
  final AccountRepository repository;

  UpdateVibeScheduleUseCase(this.repository);

  Future<void> call({
    required String userId,
    required int day,
    required int secondDay,
    required int frequency,
  }) {
    return repository.updateVibeSchedule(
      userId: userId,
      day: day,
      secondDay: secondDay,
      frequency: frequency,
    );
  }
}
