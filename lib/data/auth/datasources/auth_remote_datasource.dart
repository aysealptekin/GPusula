import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); //sahte bir gecikme ag yukleniyor

    if (email == 'test@gmail.com' && password == '123456') {
      final fakeFirebaseData = {
        'id': 'user_123',
        'email': 'test@gmail.com',
        'name': 'kullanici',
      };
      return UserModel.fromMap(fakeFirebaseData);
    } else {
      throw Exception('Giris bilgileri hatali');
    }
  }
}
