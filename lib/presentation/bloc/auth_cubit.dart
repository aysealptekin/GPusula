import 'auth_state.dart';

class AuthCubit {
  AuthState state = AuthInitial();

  Future<void> login(String email, String password) async {
    //Bu işlem hemen bitmeyecek; internete gidecek, bir cevap bekleyecek ve bir noktada (gelecekte) tamamlanacak
    state = AuthLoading();

    try {
      if (email.isEmpty || password.isEmpty) {
        state = AuthError('Email ve sifre bos olamaz');
      } else {
        state = AuthSuccess();
      }
    } catch (e) {
      state = AuthError('Giris sirasinda hata olustu');
    }
  }

  Future<void> signWithGoogle() async {
    state = AuthLoading();
  }
}
