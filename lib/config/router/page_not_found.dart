import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        title: const Text('Page Not Found'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => context.goNamed(RouteNames.home),
            child: const Text("Home"),
          ),
        ],
      ),
    );
  }
}
