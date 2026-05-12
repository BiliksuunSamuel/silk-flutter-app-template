import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/core/error/app_failure.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/features/auth/presentation/providers/auth_controller.dart';
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
  String _phone = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = ModalRoute.of(context)?.settings.arguments;
    if (extra is String) _phone = extra;
  }

  Future<void> _submit() async {
    if (_otp.length < 6) {
      setState(() => _error = 'Please enter the 6-digit code.');
      return;
    }

    setState(() => _error = null);
    await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(phone: _phone, otp: _otp);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (_, state) {
      state.whenOrNull(
        error: (e, __) => setState(
          () => _error = e is AppFailure ? e.userMessage : e.toString(),
        ),
      );
    });

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
                  key: ValueKey(authState.isLoading),
                  label: 'Verify',
                  onPressed: authState.isLoading || _otp.length < 6
                      ? null
                      : _submit,
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
