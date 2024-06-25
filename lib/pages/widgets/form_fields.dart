import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class PasswordFormField extends StatelessWidget {
  const PasswordFormField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: labelText,
        prefixIcon: const Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Password required';
        }
        if (value.trim().length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

class CnfPasswordFormField extends StatelessWidget {
  const CnfPasswordFormField({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: labelText,
        prefixIcon: const Icon(Icons.lock),
      ),
      validator: (value) {
        if (controller.text != value) {
          return 'Password not match';
        }
        return null;
      },
    );
  }
}

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        labelText: 'Email',
        hintText: 'your@email.com',
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email required';
        }
        if (!isEmail(value.trim())) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }
}

class NameFormField extends StatelessWidget {
  const NameFormField({
    super.key,
    required TextEditingController controller,
  }) : _nameController = controller;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        labelText: "Name",
        prefixIcon: Icon(Icons.account_box),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name required';
        }
        if (value.trim().length < 2 || value.trim().length > 12) {
          return 'Name must be between 2 and 12 characters long';
        }
        return null;
      },
    );
  }
}
