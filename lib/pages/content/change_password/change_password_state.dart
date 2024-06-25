import 'package:fb_auth_riverpod/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_state.g.dart';

@riverpod
class ChangePassword extends _$ChangePassword {
  @override
  FutureOr<void> build() {}

  Future<void> changePassword(String newPassword) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).changePassword(newPassword),
    );
  }
}
