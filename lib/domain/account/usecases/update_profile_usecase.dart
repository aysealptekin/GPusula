import '../repositories/account_repository.dart';

class UpdateProfileUseCase {
  final AccountRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call({
    required String userId,
    required String name,
    required String email,
    List<int>? photoBytes,
  }) {
    return repository.updateProfile(
      userId: userId,
      name: name,
      email: email,
      photoBytes: photoBytes,
    );
  }
}
