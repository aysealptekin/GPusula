import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> signInWithGoogle();

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
  final FirebaseFirestore firestore;
  final GoogleSignIn? googleSignIn;

  AuthRemoteDataSourceImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       firestore = firestore ?? FirebaseFirestore.instance,
       googleSignIn = googleSignIn ?? (kIsWeb ? null : GoogleSignIn());

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
  Future<UserModel> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = firebase_auth.GoogleAuthProvider();
        final userCredential = await firebaseAuth.signInWithPopup(provider);
        final user = userCredential.user;

        if (user != null) {
          await _createUserProfile(
            userId: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            photoUrl: user.photoURL,
          );
        }

        return _userFromFirebaseUser(user);
      }

      final googleUser = await googleSignIn?.signIn();
      if (googleUser == null) {
        throw Exception('Google ile giriş iptal edildi');
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        await _createUserProfile(
          userId: user.uid,
          name: user.displayName ?? googleUser.displayName ?? '',
          email: user.email ?? googleUser.email,
          photoUrl: user.photoURL ?? googleUser.photoUrl,
        );
      }

      return _userFromFirebaseUser(user);
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

      final user = firebaseAuth.currentUser ?? credential.user;
      if (user != null) {
        await _createUserProfile(
          userId: user.uid,
          name: name.trim(),
          email: email.trim(),
        );
      }

      return _userFromFirebaseUser(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(_authErrorMessage(e));
    }
  }

  @override
  Future<void> logout() async {
    await googleSignIn?.signOut();
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

  Future<void> _createUserProfile({
    required String userId,
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    final profileData = <String, dynamic>{
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (photoUrl != null && photoUrl.trim().isNotEmpty) {
      profileData['photoUrl'] = photoUrl;
    }

    try {
      await firestore
          .collection('users')
          .doc(userId)
          .set(profileData, SetOptions(merge: true));
    } on FirebaseException {
      // Auth kaydi basariliysa profil dokumani rules nedeniyle yazilamasa da
      // kullanicinin kaydini bozmayalim.
    }
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
