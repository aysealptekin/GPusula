import 'package:flutter_bloc/flutter_bloc.dart'; // Cubit için gerekli
import 'auth_state.dart';
import 'package:roadmap/domain/auth/usecases/login_usecase.dart';

class AuthCubit extends Cubit<AuthState> { // Cubit'ten türetilmeli
  final LoginUseCase loginUseCase;

  AuthCubit(this.loginUseCase) : super(AuthInitial()); // Başlangıç durumu verilmeli

  Future<void> login(String email, String password) async {
    emit(AuthLoading()); // state = AuthLoading yerine emit kullanılır

    try {
      // UseCase içindeki asıl metot (genellikle 'call' veya 'execute') çağrılır
      await loginUseCase.call(email: email, password: password);

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      // Google login işlemleri buraya gelir
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError('Google ile giriş sırasında hata oluştu'));
    }
  }
}