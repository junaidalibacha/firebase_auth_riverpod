import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/content/home/home_state.dart';
import 'package:fb_auth_riverpod/repositories/auth_repository.dart';
import 'package:fb_auth_riverpod/utils/extensions/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(profileProvider),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              try {
                await ref.read(authRepositoryProvider).signOut();
              } on CustomError catch (e) {
                if (!context.mounted) return;
                errorDialog(context, e);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: profileState.when(
        skipLoadingOnRefresh: false,
        data: (appUser) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome ${appUser.name}",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Profile',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                "email: ${appUser.email}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                "id: ${appUser.id}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              OutlinedButton(
                onPressed: () => context.pushNamed(RouteNames.changePassword),
                child: const Text("Change Password"),
              ),
            ],
          ),
        ),
        error: (e, _) {
          final error = e as CustomError;
          return Center(
            child: Text(
              "code: ${error.code}\nplugin:${error.plugin}\nmessage:${error.message}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
