import '../entities/user_profile.dart';
import '../repositories/account_repository.dart';

class WatchUserProfileUseCase {
  final AccountRepository repository;

  WatchUserProfileUseCase(this.repository);

  Stream<UserProfile?> call(String userId) {
    return repository.watchUserProfile(userId);
  }
}
