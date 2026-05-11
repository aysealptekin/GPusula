import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});

  Future<User> register({
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

//AuthRepository bir sayfa degil; “auth islemleri nasil cagrilacak” diye bir sozlesme.
//bu sozlesmeyi implemente eden class'lar AuthRepository'yi implemente eder.
