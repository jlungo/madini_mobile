import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable back button for app bar. Pops route when possible, else goes to [fallbackRoute].
class AppBackButton extends StatelessWidget {
  /// Route when [Navigator.canPop] is false (e.g. root pages like Profile → Home).
  final String? fallbackRoute;

  const AppBackButton({super.key, this.fallbackRoute});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (canPop) {
          context.pop();
        } else if (fallbackRoute != null) {
          context.go(fallbackRoute!);
        }
      },
    );
  }
}
