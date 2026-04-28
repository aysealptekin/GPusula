import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
  }) {
    return repository.login(
      email: email,
      password: password,
    );
  }
}
// ilk once repository'yi kullanarak 
//login islemini yapar. sonra repository'yi kullanarak user'i alir.
// sonra user'i kullanarak auth islemini yapar.    
//usecase uygulamanin tek bir isini yapar her is icin ayri usecase gerekir