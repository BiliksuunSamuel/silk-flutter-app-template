import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:silk/core/error/app_failure.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/router/route_paths.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/features/auth/presentation/providers/auth_controller.dart';
import 'package:silk/shared/widgets/silk_button.dart';
import 'package:silk/shared/widgets/silk_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _error = 'Please enter your phone number.');
      return;
    }

    setState(() => _error = null);
    final success = await ref
        .read(authControllerProvider.notifier)
        .requestOtp(phone);

    if (success && mounted) {
      unawaited(context.push(RoutePaths.otp, extra: phone));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (_, state) {
      state.whenOrNull(
        error: (Object e, _) => setState(
          () => _error = e is AppFailure ? e.userMessage : e.toString(),
        ),
      );
    });

    return Scaffold(
      backgroundColor: tokens.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text('Welcome back', style: tokens.displayStyle),
              SizedBox(height: tokens.spaceSm),
              Text(
                'Enter your phone number to continue.',
                style: tokens.bodyStyle.copyWith(color: tokens.onSurfaceMuted),
              ),
              SizedBox(height: tokens.spaceXxl),
              SilkTextField(
                hint: '+1 (555) 000-0000',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => unawaited(_submit()),
                errorText: _error,
                autofocus: true,
              ),
              SizedBox(height: tokens.spaceLg),
              AnimatedSwitcher(
                duration: MotionTokens.fast,
                child: SilkButton(
                  key: ValueKey(authState.isLoading),
                  label: 'Continue',
                  onPressed: authState.isLoading ? null : () => unawaited(_submit()),
                  isLoading: authState.isLoading,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
