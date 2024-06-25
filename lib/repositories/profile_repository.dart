import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_auth_riverpod/constants/firebase_constants.dart';
import 'package:fb_auth_riverpod/repositories/handle_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/app_user.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository();
}

class ProfileRepository {
  Future<AppUser> getProfile() async {
    final String uid = firebaseAuth.currentUser!.uid;
    try {
      final DocumentSnapshot appUserDoc = await usersCollection.doc(uid).get();

      if (appUserDoc.exists) return AppUser.fromDoc(appUserDoc);

      throw Exception('User not found');
    } catch (e) {
      throw handleException(e);
    }
  }
}
