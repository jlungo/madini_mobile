import 'package:flutter/material.dart';

import '../../../../core/config/module_config.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../widgets/module_card.dart';

/// Landing dashboard showing the four main NGMRIS modules,
/// matching the web dashboard design with large centered cards.
class SwitchboardPage extends StatelessWidget {
  const SwitchboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: kModules.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final module = kModules[index];
            return ModuleCard(module: module);
          },
        ),
      ),
    );
  }
}

