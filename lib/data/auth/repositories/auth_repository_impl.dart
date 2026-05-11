//usecase, repository’yi cagirir
//repository impl, datasource’u cagirir
//datasource, veriyi getirir

import '../../../domain/auth/entities/user.dart';
import '../../../domain/auth/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login({required String email, required String password}) {
    return remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) {
    return remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return remoteDataSource.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> resetPassword({required String email}) {
    return remoteDataSource.resetPassword(email: email);
  }
}
