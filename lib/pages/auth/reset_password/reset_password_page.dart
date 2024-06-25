import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/pages/auth/reset_password/reset_password_state.dart';
import 'package:fb_auth_riverpod/pages/widgets/cutom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/custom_error.dart';
import '../../../utils/extensions/error_dialog.dart';
import '../../widgets/form_fields.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(resetPasswordProvider.notifier).resetPassword(
          email: _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(resetPasswordProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password reset email has been sent"),
            ),
          );
          context.goNamed(RouteNames.signIn);
        },
        error: (error, stackTrace) => errorDialog(
          context,
          error as CustomError,
        ),
      );
    });

    final resetPwdState = ref.watch(resetPasswordProvider);

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
                const FlutterLogo(size: 150),
                const SizedBox(height: 20),
                EmailFormField(emailController: _emailController),
                const SizedBox(height: 40),
                CustomButton(
                  onPressed: resetPwdState.maybeWhen(
                    loading: () => null,
                    orElse: () => _submit,
                  ),
                  child: Text(
                    resetPwdState.maybeWhen(
                      loading: () => "Submitting...",
                      orElse: () => "Reset Password",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Remember password?"),
                    TextButton(
                      onPressed: resetPwdState.maybeWhen(
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
