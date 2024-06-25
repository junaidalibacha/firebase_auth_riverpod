import 'package:fb_auth_riverpod/constants/firebase_constants.dart';
import 'package:fb_auth_riverpod/repositories/handle_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepository();

class AuthRepository {
  User? get _currentUser => firebaseAuth.currentUser;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final signedInUser = userCredential.user;
      if (signedInUser != null) {
        await usersCollection.doc(signedInUser.uid).set({
          'name': name,
          'email': email,
        });
      }
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _currentUser?.sendEmailVerification();
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> changePassword(String password) async {
    try {
      await _currentUser?.updatePassword(password);
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> reloadUser() async {
    try {
      await _currentUser?.reload();
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> reAuthenticateWithCredential(
    String email,
    String password,
  ) async {
    try {
      await _currentUser?.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: email,
          password: password,
        ),
      );
    } catch (e) {
      throw handleException(e);
    }
  }
}
