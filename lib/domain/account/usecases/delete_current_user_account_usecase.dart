import '../repositories/account_repository.dart';

class DeleteCurrentUserAccountUseCase {
  final AccountRepository repository;

  DeleteCurrentUserAccountUseCase(this.repository);

  Future<void> call({required String password}) {
    return repository.deleteCurrentUserAccount(password: password);
  }
}
