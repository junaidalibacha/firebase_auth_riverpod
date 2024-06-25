import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/auth/sign_in/sign_in_state.dart';
import 'package:fb_auth_riverpod/pages/widgets/form_fields.dart';
import 'package:fb_auth_riverpod/utils/extensions/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/route_names.dart';
import '../../widgets/cutom_buttom.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(signInProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signInProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) => errorDialog(
          context,
          error as CustomError,
        ),
      );
    });

    final signInState = ref.watch(signInProvider);

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
                const SizedBox(height: 20),
                PasswordFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    onPressed: signInState.maybeWhen(
                      loading: () => null,
                      orElse: () =>
                          () => context.pushNamed(RouteNames.resetPassword),
                    ),
                    child: const Text("Forgot Password?"),
                  ),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  onPressed: signInState.maybeWhen(
                    loading: () => null,
                    orElse: () => _submit,
                  ),
                  child: Text(
                    signInState.maybeWhen(
                      loading: () => "Signing...",
                      orElse: () => "Sign in",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?"),
                    TextButton(
                      onPressed: signInState.maybeWhen(
                        loading: null,
                        orElse: () => () => context.goNamed(RouteNames.signUp),
                      ),
                      child: const Text("Sign up"),
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
