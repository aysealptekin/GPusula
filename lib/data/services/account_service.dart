import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';

class AccountService {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  AccountService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       firestore = firestore ?? FirebaseFirestore.instance,
       storage = storage ?? FirebaseStorage.instance;

  Stream<Map<String, dynamic>?> watchUserProfile(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map((doc) {
      return doc.data();
    });
  }

  Future<void> clearTransactionHistory(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .get();

    final batches = <WriteBatch>[];
    var batch = firestore.batch();
    var operationCount = 0;

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
      operationCount++;

      if (operationCount == 450) {
        batches.add(batch);
        batch = firestore.batch();
        operationCount = 0;
      }
    }

    if (operationCount > 0) {
      batches.add(batch);
    }

    for (final batch in batches) {
      await batch.commit();
    }
  }

  Future<void> updateProfile({
    required String userId,
    required String name,
    required String email,
    List<int>? photoBytes,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception('Ad soyad bos olamaz');
    }

    final user = firebaseAuth.currentUser;
    String? photoUrl;

    if (photoBytes != null) {
      final ref = storage.ref('users/$userId/profile.jpg');
      await ref.putData(
        Uint8List.fromList(photoBytes),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      photoUrl = await ref.getDownloadURL();
    }

    final profileData = <String, dynamic>{
      'name': name.trim(),
      'email': email,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (photoUrl != null) {
      profileData['photoUrl'] = photoUrl;
    }

    await firestore
        .collection('users')
        .doc(userId)
        .set(profileData, SetOptions(merge: true));

    await user?.updateDisplayName(name.trim());
    if (photoUrl != null) {
      await user?.updatePhotoURL(photoUrl);
    }
  }

  Future<void> deleteCurrentUserAccount({required String password}) async {
    final user = firebaseAuth.currentUser;
    final email = user?.email;

    if (user == null || email == null) {
      throw Exception('Hesap silmek icin giris yapmalisin');
    }

    if (password.isEmpty) {
      throw Exception('Hesabi silmek icin sifreni girmelisin');
    }

    final credential = firebase_auth.EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    try {
      await user.reauthenticateWithCredential(credential);
      await clearTransactionHistory(user.uid);
      await firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw Exception(_authErrorMessage(error));
    } on FirebaseException catch (error) {
      throw Exception(error.message ?? 'Firebase islemi basarisiz oldu');
    }
  }

  String _authErrorMessage(firebase_auth.FirebaseAuthException error) {
    switch (error.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return 'Sifre hatali';
      case 'requires-recent-login':
        return 'Bu islem icin tekrar giris yapmalisin';
      default:
        return error.message ?? 'Kimlik dogrulama hatasi';
    }
  }
}
