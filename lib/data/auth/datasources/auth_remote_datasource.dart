import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

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
  final firebase_auth.FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({firebase_auth.FirebaseAuth? firebaseAuth})
    : firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      throw Exception('Sifre alanlari bos olamaz');
    }

    if (newPassword.length < 6) {
      throw Exception('Yeni sifre en az 6 karakter olmali');
    }

    final user = firebaseAuth.currentUser;
    final email = user?.email;

    if (user == null || email == null) {
      throw Exception('Sifre degistirmek icin tekrar giris yapmalisin');
    }

    final credential = firebase_auth.EmailAuthProvider.credential(
      email: email,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _userFromFirebaseUser(credential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      throw Exception('Kayit bilgileri eksik');
    }

    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();

      return _userFromFirebaseUser(firebaseAuth.currentUser ?? credential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    if (email.trim().isEmpty) {
      throw Exception('E-posta adresi gerekli');
    }

    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  UserModel _userFromFirebaseUser(firebase_auth.User? user) {
    if (user == null) {
      throw Exception('Kullanici bilgisi alinamadi');
    }

    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? user.email?.split('@').first ?? '',
    );
  }

  String _authErrorMessage(firebase_auth.FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'E-posta adresi gecersiz';
      case 'user-disabled':
        return 'Bu kullanici hesabi devre disi';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Giris bilgileri hatali';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullaniliyor';
      case 'weak-password':
        return 'Sifre daha guclu olmali';
      case 'requires-recent-login':
        return 'Bu islem icin tekrar giris yapmalisin';
      default:
        return error.message ?? 'Kimlik dogrulama hatasi';
    }
  }
}
