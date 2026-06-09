import '../../../domain/account/entities/user_profile.dart';
import '../../../domain/account/repositories/account_repository.dart';
import '../../services/account_service.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountService accountService;

  AccountRepositoryImpl(this.accountService);

  @override
  Stream<UserProfile?> watchUserProfile(String userId) {
    return accountService.watchUserProfile(userId).map((profile) {
      if (profile == null) return null;

      return UserProfile(
        name: profile['name'] as String? ?? '',
        email: profile['email'] as String? ?? '',
        photoUrl: profile['photoUrl'] as String?,
        vibeCheckDay: profile['vibeCheckDay'] as int? ?? 28,
        vibeCheckSecondDay: profile['vibeCheckSecondDay'] as int? ?? 15,
        vibeCheckFrequency: profile['vibeCheckFrequency'] as int? ?? 1,
      );
    });
  }

  @override
  Future<void> clearTransactionHistory(String userId) {
    return accountService.clearTransactionHistory(userId);
  }

  @override
  Future<void> updateProfile({
    required String userId,
    required String name,
    required String email,
    List<int>? photoBytes,
  }) {
    return accountService.updateProfile(
      userId: userId,
      name: name,
      email: email,
      photoBytes: photoBytes,
    );
  }

  @override
  Future<void> updateVibeSchedule({
    required String userId,
    required int day,
    required int secondDay,
    required int frequency,
  }) {
    return accountService.updateVibeSchedule(
      userId: userId,
      day: day,
      secondDay: secondDay,
      frequency: frequency,
    );
  }

  @override
  Future<void> deleteCurrentUserAccount({required String password}) {
    return accountService.deleteCurrentUserAccount(password: password);
  }
}
