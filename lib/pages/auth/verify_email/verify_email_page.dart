import 'dart:async';

import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/constants/firebase_constants.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/repositories/auth_repository.dart';
import 'package:fb_auth_riverpod/utils/extensions/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  Timer? _timer;

  @override
  void initState() {
    _sendEmailVerification();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkEmailVerification();
    });
    super.initState();
  }

  Future<void> _sendEmailVerification() async {
    try {
      ref.read(authRepositoryProvider).sendEmailVerification();
    } on CustomError catch (e) {
      showErrorDialog(e);
    }
  }

  Future<void> _checkEmailVerification() async {
    void goNext() => context.goNamed(RouteNames.home);

    try {
      await ref.read(authRepositoryProvider).reloadUser();

      if (firebaseAuth.currentUser?.emailVerified == true) {
        _timer?.cancel();
        goNext();
      }
    } on CustomError catch (e) {
      showErrorDialog(e);
    }
  }

  void showErrorDialog(CustomError e) => errorDialog(context, e);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Verification email has been to"),
                  Text("${firebaseAuth.currentUser?.email}"),
                  const Text("If you cant find verification email,"),
                  RichText(
                    text: const TextSpan(
                      text: 'Please check ',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "SPAM",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' folder.'),
                      ],
                    ),
                  ),
                  const Text("or, your email is incorrect."),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                try {
                  await ref.read(authRepositoryProvider).signOut();
                  _timer?.cancel();
                } on CustomError catch (e) {
                  showErrorDialog(e);
                }
              },
              child: const Text(
                "CANCEL",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
