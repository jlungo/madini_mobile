import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../../../../shared/widgets/app_scaffold.dart';

/// Profile screen: name, email, roles, permissions, logout (plan §6).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) {
      return const AppScaffold(
        title: 'Profile',
        body: Center(child: Text('Not signed in')),
      );
    }

    return AppScaffold(
      title: 'Profile',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(title: 'Account', children: [
            _Row(label: 'Name', value: '${user.firstName} ${user.lastName}'.trim()),
            _Row(label: 'Email', value: user.email),
            _Row(label: 'Username', value: user.username),
          ]),
          if (user.roles.isNotEmpty) ...[
            const SizedBox(height: 16),
            _Section(
              title: 'Roles',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: user.roles.map((r) => Chip(label: Text(r))).toList(),
              ),
            ),
          ],
          if (user.permissions.isNotEmpty) ...[
            const SizedBox(height: 16),
            _Section(
              title: 'Permissions',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: user.permissions
                    .take(20)
                    .map((p) => Chip(label: Text(p, style: const TextStyle(fontSize: 11))))
                    .toList(),
              ),
            ),
            if (user.permissions.length > 20)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+ ${user.permissions.length - 20} more',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget>? children;
  final Widget? child;

  const _Section({required this.title, this.children, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 8),
        if (children != null) ...children!,
        if (child != null) child!,
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
