import 'package:fb_auth_riverpod/constants/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state.g.dart';

@riverpod
Stream<User?> authState(AuthStateRef ref) => firebaseAuth.authStateChanges();
