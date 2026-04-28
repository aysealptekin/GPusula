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
  Future<User> login({
    required String email,
    required String password,
  }) async {
    return remoteDataSource.login(
      email: email,
      password: password,
    );
  }
}