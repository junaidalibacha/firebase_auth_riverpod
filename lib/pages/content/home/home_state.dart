import 'package:fb_auth_riverpod/models/app_user.dart';
import 'package:fb_auth_riverpod/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_state.g.dart';

@riverpod
FutureOr<AppUser> profile(ProfileRef ref) {
  return ref.watch(profileRepositoryProvider).getProfile();
}
