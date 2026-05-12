import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/features/auth/presentation/providers/auth_controller.dart';
import 'package:silk/shared/widgets/silk_app_bar.dart';
import 'package:silk/shared/widgets/silk_button.dart';

class HomeStubScreen extends ConsumerWidget {
  const HomeStubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.surface,
      appBar: const SilkAppBar(title: 'Home', showBackButton: false),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Template ready.',
                style: tokens.titleStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: tokens.spaceSm),
              Text(
                'Build your features on top of this foundation.',
                style: tokens.bodyStyle.copyWith(
                  color: tokens.onSurfaceMuted,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: tokens.spaceXxl),
              SilkButton(
                label: 'Sign out',
                variant: SilkButtonVariant.ghost,
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
