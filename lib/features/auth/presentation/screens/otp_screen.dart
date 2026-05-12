import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/features/auth/domain/session.dart';
import 'package:silk/features/auth/presentation/providers/session_provider.dart';
import 'package:silk/features/auth/presentation/widgets/otp_input.dart';
import 'package:silk/shared/widgets/silk_app_bar.dart';
import 'package:silk/shared/widgets/silk_button.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String _otp = '';
  String? _error;
  bool _loading = false;

  Future<void> _submit() async {
    if (_otp.length < 6) {
      setState(() => _error = 'Please enter the 6-digit code.');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    // Template demo: skip real OTP verification, set a stub session.
    // Replace with the block below for production:
    //   await ref.read(authControllerProvider.notifier).verifyOtp(phone: _phone, otp: _otp);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    await ref.read(sessionNotifierProvider.notifier).setSession(
      const Session(userId: 'demo', accessToken: 'demo', refreshToken: 'demo'),
    );
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.surface,
      appBar: const SilkAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text('Verify your number', style: tokens.displayStyle),
              SizedBox(height: tokens.spaceSm),
              Text(
                'Enter the 6-digit code sent to your phone.',
                style: tokens.bodyStyle.copyWith(color: tokens.onSurfaceMuted),
              ),
              SizedBox(height: tokens.spaceXxl),
              OtpInput(
                length: 6,
                onCompleted: (otp) {
                  setState(() {
                    _otp = otp;
                    _error = null;
                  });
                },
                onChanged: (otp) => setState(() => _otp = otp),
              ),
              if (_error != null) ...[
                SizedBox(height: tokens.spaceSm),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: tokens.captionStyle.copyWith(color: tokens.danger),
                ),
              ],
              SizedBox(height: tokens.spaceLg),
              AnimatedSwitcher(
                duration: MotionTokens.fast,
                child: SilkButton(
                  key: ValueKey(_loading),
                  label: 'Verify',
                  onPressed: _loading || _otp.length < 6 ? null : () => unawaited(_submit()),
                  isLoading: _loading,
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
