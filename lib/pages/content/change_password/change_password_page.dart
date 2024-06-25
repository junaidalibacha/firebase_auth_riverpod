import 'package:fb_auth_riverpod/pages/content/change_password/change_password_state.dart';
import 'package:fb_auth_riverpod/pages/widgets/form_fields.dart';
import 'package:fb_auth_riverpod/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/route_names.dart';
import '../../../models/custom_error.dart';
import '../../../utils/extensions/error_dialog.dart';
import '../../widgets/cutom_buttom.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _pwdController = TextEditingController();

  @override
  void dispose() {
    _pwdController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(changePasswordProvider.notifier).changePassword(
          _pwdController.text.trim(),
        );
  }

  void processSuccessCase() async {
    void showErrorDialog(CustomError e) => errorDialog(context, e);

    try {
      await ref.read(authRepositoryProvider).signOut();
    } on CustomError catch (e) {
      showErrorDialog(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(changePasswordProvider, (previous, next) {
      next.whenOrNull(
        data: (_) => processSuccessCase(),
        error: (error, stackTrace) => errorDialog(
          context,
          error as CustomError,
        ),
      );
    });

    final changePwdState = ref.watch(changePasswordProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: ListView(
              shrinkWrap: true,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                const Text(
                  "If you change password,",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const Text.rich(
                  TextSpan(
                    text: "you will be ",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      TextSpan(
                        text: "signed out!",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                PasswordFormField(
                  labelText: 'New Password',
                  controller: _pwdController,
                ),
                const SizedBox(height: 20),
                CnfPasswordFormField(
                  controller: _pwdController,
                  labelText: "Confirm new Password",
                ),
                const SizedBox(height: 40),
                CustomButton(
                  onPressed: changePwdState.maybeWhen(
                    loading: () => null,
                    orElse: () => _submit,
                  ),
                  child: Text(
                    changePwdState.maybeWhen(
                      loading: () => "Submitting...",
                      orElse: () => "Change Password",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Remember password?"),
                    TextButton(
                      onPressed: changePwdState.maybeWhen(
                        loading: null,
                        orElse: () => () => context.goNamed(RouteNames.signIn),
                      ),
                      child: const Text("Sign In"),
                    ),
                  ],
                ),
              ].reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }
}
