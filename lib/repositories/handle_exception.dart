import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:firebase_auth/firebase_auth.dart';

CustomError handleException(e) {
  try {
    throw e;
  } on FirebaseAuthException catch (e) {
    return CustomError(
      code: e.code,
      message: e.message ?? 'Invalid Credential',
      plugin: e.plugin,
    );
  } on FirebaseException catch (e) {
    return CustomError(
      code: e.code,
      message: e.message ?? 'Firebase Error',
      plugin: e.plugin,
    );
  } catch (e) {
    return CustomError(
      code: "Unexpected error",
      message: e.toString(),
      plugin: "Exception",
    );
  }
}
