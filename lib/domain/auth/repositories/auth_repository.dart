import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });
}
//AuthRepository bir sayfa degil; “auth islemleri nasil cagrilacak” diye bir sozlesme.
//bu sozlesmeyi implemente eden class'lar AuthRepository'yi implemente eder.
