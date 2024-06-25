import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:flutter/material.dart';

Future<void> errorDialog(BuildContext context, CustomError e) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(e.code),
      content: Text('plugin: ${e.plugin}\n\n${e.message}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
