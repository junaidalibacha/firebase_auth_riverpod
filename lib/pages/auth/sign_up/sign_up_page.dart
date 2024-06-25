import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/auth/sign_up/sign_up_state.dart';
import 'package:fb_auth_riverpod/pages/widgets/cutom_buttom.dart';
import 'package:fb_auth_riverpod/utils/extensions/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/form_fields.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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

    ref.read(signUpProvider.notifier).signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signUpProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) => errorDialog(
          context,
          error as CustomError,
        ),
      );
    });

    final signUpState = ref.watch(signUpProvider);

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
                NameFormField(controller: _nameController),
                const SizedBox(height: 20),
                EmailFormField(emailController: _emailController),
                const SizedBox(height: 20),
                PasswordFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                ),
                const SizedBox(height: 20),
                CnfPasswordFormField(
                  controller: _passwordController,
                  labelText: 'Confirm Password',
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: signUpState.maybeWhen(
                    loading: () => null,
                    orElse: () => _submit,
                  ),
                  child: Text(
                    signUpState.maybeWhen(
                      loading: () => "Submitting...",
                      orElse: () => "Sign up",
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?"),
                    TextButton(
                      onPressed: signUpState.maybeWhen(
                        loading: null,
                        orElse: () => () => context.goNamed(RouteNames.signIn),
                      ),
                      child: const Text("Sign in"),
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
