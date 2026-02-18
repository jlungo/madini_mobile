import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/module_config.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/permission_guard.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/module_card.dart';

/// Landing dashboard showing the four main NGMRIS modules,
/// matching the web dashboard design with large centered cards.
class SwitchboardPage extends StatelessWidget {
  const SwitchboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => context.go('/profile'),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => context.read<AuthProvider>().logout(),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: kModules.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final module = kModules[index];
            
            // Example of using PermissionGuard for specific modules
            if (module.id == 'laboratory') {
              return PermissionGuard.single(
                permission: 'lab:view',
                child: ModuleCard(module: module),
              );
            }
            
            return ModuleCard(module: module);
          },
        ),
      ),
    );
  }
}

