import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<void> resetPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      throw Exception('Sifre alanlari bos olamaz');
    }

    if (newPassword.length < 6) {
      throw Exception('Yeni sifre en az 6 karakter olmali');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); //sahte bir gecikme ag yukleniyor

    if (email == 'test@gmail.com' && password == '123456A') {
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

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      throw Exception('Kayit bilgileri eksik');
    }

    final fakeFirebaseData = {
      'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'email': email.trim(),
      'name': name.trim(),
    };

    return UserModel.fromMap(fakeFirebaseData);
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.trim().isEmpty) {
      throw Exception('E-posta adresi gerekli');
    }
  }
}
