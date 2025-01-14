import 'package:fb_auth_riverpod/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_state.g.dart';

@riverpod
class SignUp extends _$SignUp {
  Object? _key;

  @override
  FutureOr<void> build() {
    _key = Object();
    ref.onDispose(() => _key = null);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    final key = _key;

    final newState = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUp(
            name: name,
            email: email,
            password: password,
          ),
    );

    if (key == _key) state = newState;
  }
}
