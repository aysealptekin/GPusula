import '../entities/user_profile.dart';

abstract class AccountRepository {
  Stream<UserProfile?> watchUserProfile(String userId);

  Future<void> clearTransactionHistory(String userId);

  Future<void> updateProfile({
    required String userId,
    required String name,
    required String email,
    List<int>? photoBytes,
  });

  Future<void> deleteCurrentUserAccount({required String password});
}
