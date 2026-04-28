import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); //sahte bir gecikme ag yukleniyor

    if (email == 'test@test.com' && password == '123456') {
      return const UserModel(
        id: '1',
        email: 'test@test.com',
        name: 'Test User',
      );
    }

    throw Exception('Giris bilgileri hatali');
  }
}