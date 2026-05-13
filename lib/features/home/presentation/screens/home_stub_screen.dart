import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/core/theme/theme_mode_provider.dart';
import 'package:silk/features/auth/presentation/providers/session_provider.dart';
import 'package:silk/shared/widgets/silk_accordion.dart';
import 'package:silk/shared/widgets/silk_action_sheet.dart';
import 'package:silk/shared/widgets/silk_alert.dart';
import 'package:silk/shared/widgets/silk_amount_field.dart';
import 'package:silk/shared/widgets/silk_animated_counter.dart';
import 'package:silk/shared/widgets/silk_app_bar.dart';
import 'package:silk/shared/widgets/silk_avatar.dart';
import 'package:silk/shared/widgets/silk_avatar_group.dart';
import 'package:silk/shared/widgets/silk_badge.dart';
import 'package:silk/shared/widgets/silk_banner.dart';
import 'package:silk/shared/widgets/silk_bar_chart.dart';
import 'package:silk/shared/widgets/silk_biometric_button.dart';
import 'package:silk/shared/widgets/silk_bottom_nav_bar.dart';
import 'package:silk/shared/widgets/silk_bottom_sheet.dart';
import 'package:silk/shared/widgets/silk_button.dart';
import 'package:silk/shared/widgets/silk_calendar.dart';
import 'package:silk/shared/widgets/silk_card.dart';
import 'package:silk/shared/widgets/silk_carousel.dart';
import 'package:silk/shared/widgets/silk_chat_bubble.dart';
import 'package:silk/shared/widgets/silk_checkbox.dart';
import 'package:silk/shared/widgets/silk_chip.dart';
import 'package:silk/shared/widgets/silk_confetti.dart';
import 'package:silk/shared/widgets/silk_context_menu.dart';
import 'package:silk/shared/widgets/silk_copy_field.dart';
import 'package:silk/shared/widgets/silk_countdown_timer.dart';
import 'package:silk/shared/widgets/silk_country_picker.dart';
import 'package:silk/shared/widgets/silk_currency_picker.dart';
import 'package:silk/shared/widgets/silk_date_picker.dart';
import 'package:silk/shared/widgets/silk_date_range_picker.dart';
import 'package:silk/shared/widgets/silk_date_time_picker.dart';
import 'package:silk/shared/widgets/silk_dialog.dart';
import 'package:silk/shared/widgets/silk_divider.dart';
import 'package:silk/shared/widgets/silk_document_picker.dart';
import 'package:silk/shared/widgets/silk_donut_chart.dart';
import 'package:silk/shared/widgets/silk_dropdown.dart';
import 'package:silk/shared/widgets/silk_empty_state.dart';
import 'package:silk/shared/widgets/silk_expandable.dart';
import 'package:silk/shared/widgets/silk_expandable_text.dart';
import 'package:silk/shared/widgets/silk_fab.dart';
import 'package:silk/shared/widgets/silk_file_upload_zone.dart';
import 'package:silk/shared/widgets/silk_floating_label_input.dart';
import 'package:silk/shared/widgets/silk_gauge_chart.dart';
import 'package:silk/shared/widgets/silk_heatmap.dart';
import 'package:silk/shared/widgets/silk_icon_button.dart';
import 'package:silk/shared/widgets/silk_infinite_scroll.dart';
import 'package:silk/shared/widgets/silk_keypad.dart';
import 'package:silk/shared/widgets/silk_line_chart.dart';
import 'package:silk/shared/widgets/silk_list_tile.dart';
import 'package:silk/shared/widgets/silk_loading_overlay.dart';
import 'package:silk/shared/widgets/silk_markdown_text.dart';
import 'package:silk/shared/widgets/silk_month_picker.dart';
import 'package:silk/shared/widgets/silk_multi_value_select_input.dart';
import 'package:silk/shared/widgets/silk_number_range_picker.dart';
import 'package:silk/shared/widgets/silk_numeric_stepper.dart';
import 'package:silk/shared/widgets/silk_otp_field.dart';
import 'package:silk/shared/widgets/silk_password_strength.dart';
import 'package:silk/shared/widgets/silk_phone_input.dart';
import 'package:silk/shared/widgets/silk_pie_chart.dart';
import 'package:silk/shared/widgets/silk_pin_dots.dart';
import 'package:silk/shared/widgets/silk_progress_bar.dart';
import 'package:silk/shared/widgets/silk_progress_ring.dart';
import 'package:silk/shared/widgets/silk_pull_to_refresh.dart';
import 'package:silk/shared/widgets/silk_radio_group.dart';
import 'package:silk/shared/widgets/silk_rating.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';
import 'package:silk/shared/widgets/silk_receipt_card.dart';
import 'package:silk/shared/widgets/silk_search_bar.dart';
import 'package:silk/shared/widgets/silk_segmented_control.dart';
import 'package:silk/shared/widgets/silk_shimmer.dart';
import 'package:silk/shared/widgets/silk_signature_pad.dart';
import 'package:silk/shared/widgets/silk_skeleton.dart';
import 'package:silk/shared/widgets/silk_slider.dart';
import 'package:silk/shared/widgets/silk_sort_filter_bar.dart';
import 'package:silk/shared/widgets/silk_sparkline.dart';
import 'package:silk/shared/widgets/silk_stat_card.dart';
import 'package:silk/shared/widgets/silk_step_wizard.dart';
import 'package:silk/shared/widgets/silk_stepper.dart';
import 'package:silk/shared/widgets/silk_swipe_action.dart';
import 'package:silk/shared/widgets/silk_swipe_to_confirm.dart';
import 'package:silk/shared/widgets/silk_switch.dart';
import 'package:silk/shared/widgets/silk_tab_bar.dart';
import 'package:silk/shared/widgets/silk_table_view.dart';
import 'package:silk/shared/widgets/silk_tag.dart';
import 'package:silk/shared/widgets/silk_text_area.dart';
import 'package:silk/shared/widgets/silk_text_field.dart';
import 'package:silk/shared/widgets/silk_time_picker.dart';
import 'package:silk/shared/widgets/silk_timeline.dart';
import 'package:silk/shared/widgets/silk_toast.dart';
import 'package:silk/shared/widgets/silk_toggle_card.dart';
import 'package:silk/shared/widgets/silk_tooltip.dart';

class HomeStubScreen extends ConsumerStatefulWidget {
  const HomeStubScreen({super.key});

  @override
  ConsumerState<HomeStubScreen> createState() => _HomeStubScreenState();
}

class _HomeStubScreenState extends ConsumerState<HomeStubScreen> {
  final _textController = TextEditingController();

  DateTime? _date;
  TimeOfDay? _time;
  DateTime? _dateTime;
  DateTime? _calendarDate;
  String? _dropdownValue;
  List<String> _multiValues = [];

  bool _switchOn = false;
  bool _checkboxA = false;
  bool _checkboxB = true;
  String _segment = 'week';
  String? _radioValue;
  double _progressValue = 0.35;
  int _stepperStep = 1;
  int _navIndex = 1;
  String _activeTab = 'all';
  double _sliderValue = 0.4;
  bool _overlayVisible = false;
  String? _otpError;
  final _searchController = TextEditingController();
  int _countdownKey = 0;
  int _numericStepperValue = 1;
  double _counterValue = 84320.50;
  double _ringValue = 0.72;
  String _keypadInput = '';
  SilkDocumentStatus _docStatus = SilkDocumentStatus.empty;
  String? _docName;
  SilkDateRange? _dateRange;
  final _infiniteItems = List<int>.generate(8, (i) => i + 1);
  bool _infiniteLoading = false;
  bool _infiniteHasMore = true;
  double _rating = 3.5;
  String? _sortFilter;
  bool _sortActive = false;
  int _pinFilled = 0;
  bool _pinError = false;
  SilkCountry? _country;
  SilkCurrency? _currency;
  bool _swipeConfirmed = false;
  final _passwordController = TextEditingController();
  SilkBiometricState _bioState = SilkBiometricState.idle;
  String _plan = 'basic';
  DateTime? _reportMonth;
  double _rangeStart = 1000;
  double _rangeEnd = 8000;
  final _textAreaController = TextEditingController();
  final _sigCtrl = SilkSignaturePadController();
  int? _pieSelectedIndex;
  String? _uploadFileName;
  final _floatingInputCtrl = TextEditingController();

  static final _countries = [
    const SilkSelectItem(value: 'ng', label: 'Nigeria'),
    const SilkSelectItem(value: 'us', label: 'United States'),
    const SilkSelectItem(value: 'gb', label: 'United Kingdom'),
    const SilkSelectItem(value: 'de', label: 'Germany'),
    const SilkSelectItem(value: 'fr', label: 'France'),
    const SilkSelectItem(value: 'jp', label: 'Japan'),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _searchController.dispose();
    _passwordController.dispose();
    _textAreaController.dispose();
    _floatingInputCtrl.dispose();
    _sigCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadMoreItems() async {
    if (_infiniteLoading || !_infiniteHasMore) return;
    setState(() => _infiniteLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _infiniteItems.addAll(
        List.generate(4, (i) => _infiniteItems.length + i + 1),
      );
      _infiniteLoading = false;
      if (_infiniteItems.length >= 20) _infiniteHasMore = false;
    });
  }

  Future<void> _simulateBiometric() async {
    setState(() => _bioState = SilkBiometricState.authenticating);
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _bioState = SilkBiometricState.success);
    SilkConfetti.burst(context);
  }

  Future<void> _triggerBioFailure() async {
    setState(() => _bioState = SilkBiometricState.failure);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _bioState = SilkBiometricState.idle);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.surface,
      appBar: SilkAppBar(
        title: 'Silk UI Kit',
        showBackButton: false,
        actions: [
          SilkIconButton(
            icon: Icons.logout_outlined,
            onPressed: () =>
                ref.read(sessionNotifierProvider.notifier).clearSession(),
            variant: SilkIconButtonVariant.subtle,
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: SilkPullToRefresh(
        onRefresh: _handleRefresh,
        child: ListView(
          padding: EdgeInsets.only(bottom: tokens.spaceXxl),
          children: [
            // ── Intro ──────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                tokens.spaceLg,
                tokens.spaceLg,
                tokens.spaceLg,
                tokens.spaceSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Component showcase', style: tokens.displayStyle),
                  SizedBox(height: tokens.spaceXs),
                  Text(
                    'Every Silk* widget — interactive, token-driven, ready to use.',
                    style: tokens.bodyStyle
                        .copyWith(color: tokens.onSurfaceMuted),
                  ),
                ],
              ),
            ),

            // ── Card ──────────────────────────────────────────────────────
            _Section(
              title: 'Card',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkCard(
                      hasBorder: true,
                      child: Row(
                        children: [
                          Icon(Icons.article_outlined, color: tokens.accent),
                          SizedBox(width: tokens.spaceMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Default card', style: tokens.bodyStyle),
                                Text('hasBorder: true', style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkCard(
                      elevation: SilkCardElevation.md,
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.touch_app_outlined, color: tokens.accent),
                          SizedBox(width: tokens.spaceMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tappable + shadow', style: tokens.bodyStyle),
                                Text('elevation: md · onTap set', style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: tokens.onSurfaceMuted),
                        ],
                      ),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkCard(
                      color: tokens.accent,
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.white),
                          SizedBox(width: tokens.spaceMd),
                          Text('Custom color', style: tokens.bodyStyle.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Alert ──────────────────────────────────────────────────────
            _Section(
              title: 'Alert',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    const SilkAlert(
                      variant: SilkAlertVariant.info,
                      title: 'Verification required',
                      body: 'Please verify your email before making a transfer.',
                    ),
                    SizedBox(height: tokens.spaceSm),
                    const SilkAlert(
                      variant: SilkAlertVariant.success,
                      body: r'Payment of $250.00 was sent successfully.',
                    ),
                    SizedBox(height: tokens.spaceSm),
                    const SilkAlert(
                      variant: SilkAlertVariant.warning,
                      title: 'Account limit approaching',
                      body: 'You have used 80% of your monthly transaction limit.',
                    ),
                    SizedBox(height: tokens.spaceSm),
                    SilkAlert(
                      variant: SilkAlertVariant.danger,
                      body: 'Transaction failed. Please try again.',
                      onDismiss: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Tab Bar ────────────────────────────────────────────────────
            _Section(
              title: 'Tab Bar',
              child: SilkTabBar<String>(
                selected: _activeTab,
                onSelected: (v) => setState(() => _activeTab = v),
                tabs: const [
                  SilkTab(value: 'all',      label: 'All'),
                  SilkTab(value: 'active',   label: 'Active',  badge: 3),
                  SilkTab(value: 'pending',  label: 'Pending', badge: 12),
                  SilkTab(value: 'closed',   label: 'Closed'),
                  SilkTab(value: 'archived', label: 'Archived'),
                ],
              ),
            ),

            // ── OTP Field ──────────────────────────────────────────────────
            _Section(
              title: 'OTP Field',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkOTPField(
                      length: 6,
                      errorText: _otpError,
                      onChanged: (_) => setState(() => _otpError = null),
                      onCompleted: (otp) => setState(
                        () => _otpError = otp == '123456' ? null : 'Invalid code',
                      ),
                    ),
                    SizedBox(height: tokens.spaceSm),
                    Text(
                      'Type 123456 for success · anything else shows error',
                      style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkOTPField(
                      length: 4,
                      obscure: true,
                      onCompleted: (_) {},
                    ),
                    SizedBox(height: tokens.spaceXs),
                    Text(
                      'PIN mode (obscured, 4-digit)',
                      style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // ── Amount Field ───────────────────────────────────────────────
            _Section(
              title: 'Amount Field',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    const SilkAmountField(
                      label: 'Amount',
                      currency: r'$',
                    ),
                    SizedBox(height: tokens.spaceMd),
                    const SilkAmountField(
                      label: 'Amount (GHS)',
                      currency: '₵',
                      decimalPlaces: 2,
                    ),
                    SizedBox(height: tokens.spaceMd),
                    const SilkAmountField(
                      label: 'Whole numbers only',
                      currency: '₦',
                      decimalPlaces: 0,
                      errorText: 'Amount exceeds transfer limit',
                    ),
                  ],
                ),
              ),
            ),

            // ── Phone Input ────────────────────────────────────────────────
            _Section(
              title: 'Phone Input',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: const SilkPhoneInput(
                  label: 'Mobile number',
                ),
              ),
            ),

            // ── Slider ─────────────────────────────────────────────────────
            _Section(
              title: 'Slider',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkSlider(
                      value: _sliderValue,
                      label: 'Investment amount',
                      showValue: true,
                      valueFormatter: (v) => '\$${(v * 10000).toStringAsFixed(0)}', // ignore: use_raw_strings - interpolation required
                      onChanged: (v) => setState(() => _sliderValue = v),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkSlider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: 'Risk tolerance',
                      showValue: true,
                      valueFormatter: (v) => '${v.toStringAsFixed(0)}%',
                      onChanged: (v) => setState(() => _sliderValue = v / 100),
                    ),
                  ],
                ),
              ),
            ),

            // ── Expandable ─────────────────────────────────────────────────
            _Section(
              title: 'Expandable',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkExpandable(
                      title: Text('What is a collateral?', style: tokens.bodyStyle),
                      child: Text(
                        'Collateral is an asset pledged by a borrower to secure a loan. If the borrower defaults, the lender can seize the collateral to recover losses.',
                        style: tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ),
                    Divider(color: tokens.divider, height: 1),
                    SilkExpandable(
                      title: Text('How are returns calculated?', style: tokens.bodyStyle),
                      initiallyExpanded: true,
                      child: Text(
                        'Returns are calculated on a pro-rata basis according to your investment amount and the agreed interest rate over the investment period.',
                        style: tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ),
                    Divider(color: tokens.divider, height: 1),
                    SilkExpandable(
                      title: Text('What happens at maturity?', style: tokens.bodyStyle),
                      child: Text(
                        'At maturity, your principal plus accrued returns are credited to your wallet automatically within 24 hours.',
                        style: tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Expandable Text ────────────────────────────────────────────
            _Section(
              title: 'Expandable Text',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: const SilkExpandableText(
                  maxLines: 3,
                  text:
                      'Obotan is an SEC-licensed crowdfunding intermediary that connects retail investors with issuers raising capital through a regulated channel. '
                      'The platform enables investors to diversify their portfolios by participating in curated investment opportunities across various sectors, '
                      'while issuers gain access to a broad base of motivated investors who believe in their vision. '
                      'All transactions are governed by strict compliance and disclosure requirements mandated by the regulator.',
                ),
              ),
            ),

            // ── Swipe Action ───────────────────────────────────────────────
            _Section(
              title: 'Swipe Action',
              child: Column(
                children: [
                  SilkSwipeAction(
                    actions: [
                      SilkSwipeItem(
                        label: 'Archive',
                        icon: Icons.archive_outlined,
                        color: tokens.accent,
                        onTap: () {},
                      ),
                      SilkSwipeItem(
                        label: 'Delete',
                        icon: Icons.delete_outline,
                        color: tokens.danger,
                        onTap: () {},
                      ),
                    ],
                    child: SilkListTile(
                      leading: Icon(Icons.receipt_long_outlined, color: tokens.onSurfaceMuted),
                      title: Text('Payment to Acme Corp', style: tokens.bodyStyle),
                      subtitle: Text(r'May 12 · $1,200.00', style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted)),
                      trailing: Text(
                        'Completed',
                        style: tokens.captionStyle.copyWith(color: tokens.success),
                      ),
                      showDivider: false,
                      onTap: () {},
                    ),
                  ),
                  Divider(color: tokens.divider, height: 1),
                  SilkSwipeAction(
                    actions: [
                      SilkSwipeItem(
                        label: 'Archive',
                        icon: Icons.archive_outlined,
                        color: tokens.accent,
                        onTap: () {},
                      ),
                      SilkSwipeItem(
                        label: 'Delete',
                        icon: Icons.delete_outline,
                        color: tokens.danger,
                        onTap: () {},
                      ),
                    ],
                    child: SilkListTile(
                      leading: Icon(Icons.receipt_long_outlined, color: tokens.onSurfaceMuted),
                      title: Text('Wallet top-up', style: tokens.bodyStyle),
                      subtitle: Text(r'May 10 · $500.00', style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted)),
                      trailing: Text(
                        'Pending',
                        style: tokens.captionStyle.copyWith(color: const Color(0xFFF59E0B)),
                      ),
                      showDivider: false,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),

            // ── Loading Overlay ────────────────────────────────────────────
            _Section(
              title: 'Loading Overlay',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkLoadingOverlay(
                      isLoading: _overlayVisible,
                      label: 'Processing payment…',
                      child: SilkCard(
                        hasBorder: true,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.payment_outlined, color: tokens.onSurfaceMuted),
                                SizedBox(width: tokens.spaceMd),
                                Text('Payment summary', style: tokens.bodyStyle),
                              ],
                            ),
                            SizedBox(height: tokens.spaceMd),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Amount', style: tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted)),
                                Text(r'$1,200.00', style: tokens.bodySmStyle),
                              ],
                            ),
                            SizedBox(height: tokens.spaceXs),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Fee', style: tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted)),
                                Text(r'$2.50', style: tokens.bodySmStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkButton(
                      label: _overlayVisible ? 'Hide overlay' : 'Show overlay',
                      variant: SilkButtonVariant.secondary,
                      onPressed: () => setState(() => _overlayVisible = !_overlayVisible),
                    ),
                  ],
                ),
              ),
            ),

            // ── Animated Counter ───────────────────────────────────────────
            _Section(
              title: 'Animated Counter',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio value',
                      style: tokens.captionStyle
                          .copyWith(color: tokens.onSurfaceMuted),
                    ),
                    SizedBox(height: tokens.spaceXs),
                    SilkAnimatedCounter(
                      value: _counterValue,
                      prefix: '₵ ',
                      formatter: (v) => v.toStringAsFixed(2).replaceAllMapped(
                            RegExp(r'(\d)(?=(\d{3})+\.)'),
                            (m) => '${m[1]},',
                          ),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    Row(
                      children: [
                        SilkButton(
                          label: '− 1,000',
                          variant: SilkButtonVariant.secondary,
                          onPressed: () => setState(
                            () => _counterValue -= 1000,
                          ),
                        ),
                        SizedBox(width: tokens.spaceSm),
                        SilkButton(
                          label: '+ 1,000',
                          onPressed: () => setState(
                            () => _counterValue += 1000,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Progress Ring ──────────────────────────────────────────────
            _Section(
              title: 'Progress Ring',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SilkProgressRing(
                          value: _ringValue,
                          size: 80,
                          child: Text(
                            '${(_ringValue * 100).round()}%',
                            style: tokens.bodySmStyle.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SilkProgressRing(
                          value: _ringValue * 0.6,
                          size: 64,
                          strokeWidth: 6,
                          color: tokens.success,
                        ),
                        SilkProgressRing(
                          value: _ringValue * 0.3,
                          size: 48,
                          strokeWidth: 5,
                          color: const Color(0xFF6366F1),
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkSlider(
                      value: _ringValue,
                      label: 'Adjust value',
                      showValue: true,
                      valueFormatter: (v) => '${(v * 100).round()}%',
                      onChanged: (v) => setState(() => _ringValue = v),
                    ),
                  ],
                ),
              ),
            ),

            // ── Keypad ─────────────────────────────────────────────────────
            _Section(
              title: 'Keypad',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.spaceLg,
                        vertical: tokens.spaceMd,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.surfaceMuted,
                        borderRadius:
                            BorderRadius.circular(tokens.radiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _keypadInput.isEmpty ? '——' : _keypadInput,
                            style: tokens.displayStyle,
                          ),
                          if (_keypadInput.isNotEmpty)
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _keypadInput = ''),
                              child: Icon(
                                Icons.close,
                                color: tokens.onSurfaceMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkKeypad(
                      showDecimal: true,
                      onKeyTap: (digit) => setState(
                        () => _keypadInput += digit,
                      ),
                      onDelete: () => setState(() {
                        if (_keypadInput.isNotEmpty) {
                          _keypadInput = _keypadInput.substring(
                            0,
                            _keypadInput.length - 1,
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // ── Document Picker ────────────────────────────────────────────
            _Section(
              title: 'Document Picker',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkDocumentPicker(
                      label: 'Identity document',
                      hint: 'Upload passport or national ID',
                      acceptedFormats: 'PDF · JPG · PNG  ·  max 5 MB',
                      status: _docStatus,
                      fileName: _docName,
                      onPick: () => setState(() {
                        _docName = 'passport_scan.jpg';
                        _docStatus = SilkDocumentStatus.selected;
                      }),
                      onRemove: () => setState(() {
                        _docName = null;
                        _docStatus = SilkDocumentStatus.empty;
                      }),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    Wrap(
                      spacing: tokens.spaceSm,
                      runSpacing: tokens.spaceSm,
                      children: [
                        SilkButton(
                          label: 'Uploading',
                          variant: SilkButtonVariant.secondary,
                          onPressed: () => setState(() {
                            _docName = 'passport_scan.jpg';
                            _docStatus = SilkDocumentStatus.uploading;
                          }),
                        ),
                        SilkButton(
                          label: 'Done',
                          variant: SilkButtonVariant.secondary,
                          onPressed: () => setState(() {
                            _docName = 'passport_scan.jpg';
                            _docStatus = SilkDocumentStatus.done;
                          }),
                        ),
                        SilkButton(
                          label: 'Error',
                          variant: SilkButtonVariant.secondary,
                          onPressed: () => setState(() {
                            _docName = 'passport_scan.jpg';
                            _docStatus = SilkDocumentStatus.error;
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Date Range Picker ──────────────────────────────────────────
            _Section(
              title: 'Date Range Picker',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkDateRangePicker(
                  label: 'Transaction period',
                  value: _dateRange,
                  onChanged: (r) => setState(() => _dateRange = r),
                ),
              ),
            ),

            // ── Tag ────────────────────────────────────────────────────────
            _Section(
              title: 'Tag',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Wrap(
                  spacing: tokens.spaceSm,
                  runSpacing: tokens.spaceSm,
                  children: const [
                    SilkTag(label: 'Accent', variant: SilkTagVariant.accent),
                    SilkTag(label: 'Success', variant: SilkTagVariant.success),
                    SilkTag(label: 'Warning', variant: SilkTagVariant.warning),
                    SilkTag(label: 'Danger', variant: SilkTagVariant.danger),
                    SilkTag(label: 'Muted'),
                    SilkTag(
                      label: 'Verified',
                      variant: SilkTagVariant.accent,
                      icon: Icons.verified_outlined,
                    ),
                  ],
                ),
              ),
            ),

            // ── Countdown Timer ────────────────────────────────────────────
            _Section(
              title: 'Countdown Timer',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resend code in',
                              style: tokens.captionStyle
                                  .copyWith(color: tokens.onSurfaceMuted),
                            ),
                            SilkCountdownTimer(
                              key: ValueKey(_countdownKey),
                              duration: const Duration(seconds: 30),
                              onComplete: () => setState(() {}),
                            ),
                          ],
                        ),
                        SilkButton(
                          label: 'Restart',
                          variant: SilkButtonVariant.secondary,
                          onPressed: () =>
                              setState(() => _countdownKey++),
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceMd),
                    Row(
                      children: [
                        Text('Session expires: ', style: tokens.bodySmStyle),
                        SilkCountdownTimer(
                          key: ValueKey(_countdownKey + 100),
                          duration: const Duration(seconds: 90),
                          format: SilkCountdownFormat.human,
                          onComplete: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Carousel ───────────────────────────────────────────────────
            _Section(
              title: 'Carousel',
              child: SilkCarousel(
                height: 160,
                autoPlay: true,
                viewportFraction: 0.88,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: tokens.spaceXs),
                    decoration: BoxDecoration(
                      color: tokens.accent,
                      borderRadius:
                          BorderRadius.circular(tokens.radiusLg),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Investment opportunity',
                      style: tokens.titleStyle.copyWith(color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: tokens.spaceXs),
                    decoration: BoxDecoration(
                      color: tokens.success,
                      borderRadius:
                          BorderRadius.circular(tokens.radiusLg),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Portfolio growth',
                      style: tokens.titleStyle.copyWith(color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: tokens.spaceXs),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius:
                          BorderRadius.circular(tokens.radiusLg),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'New campaign live',
                      style: tokens.titleStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // ── Numeric Stepper ────────────────────────────────────────────
            _Section(
              title: 'Numeric Stepper',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity', style: tokens.bodyStyle),
                        SilkNumericStepper(
                          value: _numericStepperValue,
                          min: 1,
                          max: 10,
                          onChanged: (v) =>
                              setState(() => _numericStepperValue = v),
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceMd),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Duration', style: tokens.bodyStyle),
                        SilkNumericStepper(
                          value: _numericStepperValue,
                          min: 1,
                          max: 24,
                          formatter: (v) => '${v}mo',
                          onChanged: (v) =>
                              setState(() => _numericStepperValue = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── FAB ────────────────────────────────────────────────────────
            _Section(
              title: 'FAB',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Wrap(
                  spacing: tokens.spaceMd,
                  runSpacing: tokens.spaceMd,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SilkFAB(
                      icon: Icons.add,
                      size: SilkFABSize.sm,
                      onPressed: () {},
                    ),
                    SilkFAB(icon: Icons.add, onPressed: () {}),
                    SilkFAB(
                      icon: Icons.add,
                      size: SilkFABSize.lg,
                      onPressed: () {},
                    ),
                    SilkFAB(
                      icon: Icons.edit_outlined,
                      label: 'New investment',
                      onPressed: () {},
                    ),
                    SilkFAB(
                      icon: Icons.share_outlined,
                      variant: SilkFABVariant.surface,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Infinite Scroll ────────────────────────────────────────────
            _Section(
              title: 'Infinite Scroll',
              child: SizedBox(
                height: 280,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: _infiniteItems.length + 1,
                  itemBuilder: (context, i) {
                    if (i == _infiniteItems.length) {
                      return SilkInfiniteScroll(
                        hasMore: _infiniteHasMore,
                        isLoading: _infiniteLoading,
                        onLoadMore: _loadMoreItems,
                      );
                    }
                    final item = _infiniteItems[i];
                    return SilkListTile(
                      title: Text('Item #$item', style: tokens.bodyStyle),
                      subtitle: Text(
                        'Scroll down to load more',
                        style: tokens.captionStyle
                            .copyWith(color: tokens.onSurfaceMuted),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Confetti ──────────────────────────────────────────────────
            _Section(
              title: 'Confetti',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overlay burst — no widget setup required.',
                      style: tokens.captionStyle
                          .copyWith(color: tokens.onSurfaceMuted),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    Wrap(
                      spacing: tokens.spaceSm,
                      runSpacing: tokens.spaceSm,
                      children: [
                        SilkButton(
                          label: 'Burst!',
                          onPressed: () => SilkConfetti.burst(context),
                        ),
                        SilkButton(
                          label: 'More particles',
                          variant: SilkButtonVariant.secondary,
                          onPressed: () => SilkConfetti.burst(
                            context,
                            particleCount: 200,
                          ),
                        ),
                        SilkButton(
                          label: 'Custom colours',
                          variant: SilkButtonVariant.secondary,
                          onPressed: () => SilkConfetti.burst(
                            context,
                            colors: [
                              tokens.accent,
                              tokens.success,
                              Colors.white,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Biometric Button ──────────────────────────────────────────
            _Section(
              title: 'Biometric Button',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SilkBiometricButton(
                              type: SilkBiometricType.fingerprint,
                              state: _bioState,
                              onPressed: _simulateBiometric,
                            ),
                            SizedBox(height: tokens.spaceXs),
                            Text(
                              'Fingerprint',
                              style: tokens.captionStyle
                                  .copyWith(color: tokens.onSurfaceMuted),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SilkBiometricButton(
                              type: SilkBiometricType.faceId,
                              state: _bioState,
                              onPressed: _simulateBiometric,
                            ),
                            SizedBox(height: tokens.spaceXs),
                            Text(
                              'Face ID',
                              style: tokens.captionStyle
                                  .copyWith(color: tokens.onSurfaceMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceLg),
                    Wrap(
                      spacing: tokens.spaceSm,
                      runSpacing: tokens.spaceSm,
                      children: [
                        SilkButton(
                          label: 'Authenticate',
                          onPressed: _bioState ==
                                  SilkBiometricState.authenticating
                              ? null
                              : _simulateBiometric,
                        ),
                        SilkButton(
                          label: 'Fail',
                          variant: SilkButtonVariant.destructive,
                          onPressed: _triggerBioFailure,
                        ),
                        SilkButton(
                          label: 'Reset',
                          variant: SilkButtonVariant.secondary,
                          onPressed: () => setState(
                            () => _bioState = SilkBiometricState.idle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Copy Field ────────────────────────────────────────────────
            _Section(
              title: 'Copy Field',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    const SilkCopyField(
                      label: 'Account number',
                      value: '1234567890',
                    ),
                    SizedBox(height: tokens.spaceMd),
                    const SilkCopyField(
                      label: 'Card number',
                      value: '4111111111114242',
                      obscure: true,
                    ),
                    SizedBox(height: tokens.spaceMd),
                    const SilkCopyField(
                      label: 'Reference code',
                      value: 'TXN-2026-AB7F3C',
                    ),
                  ],
                ),
              ),
            ),

            // ── Avatar Group ──────────────────────────────────────────────
            _Section(
              title: 'Avatar Group',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SilkAvatarGroup(
                          items: [
                            const SilkAvatarItem(initials: 'AS'),
                            SilkAvatarItem(
                              initials: 'BH',
                              color: tokens.success,
                            ),
                            const SilkAvatarItem(initials: 'CK'),
                            const SilkAvatarItem(initials: 'DM'),
                            const SilkAvatarItem(initials: 'EF'),
                            const SilkAvatarItem(initials: 'GR'),
                            const SilkAvatarItem(initials: 'HT'),
                          ],
                          max: 4,
                        ),
                        SizedBox(width: tokens.spaceMd),
                        Text(
                          '7 co-investors',
                          style: tokens.bodySmStyle
                              .copyWith(color: tokens.onSurfaceMuted),
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkAvatarGroup(
                      items: [
                        SilkAvatarItem(
                          initials: 'QA',
                          color: tokens.accent,
                        ),
                        const SilkAvatarItem(
                          initials: 'WB',
                          color: Color(0xFF6366F1),
                        ),
                        const SilkAvatarItem(initials: 'EC'),
                      ],
                      size: 28,
                      overlap: 8,
                    ),
                  ],
                ),
              ),
            ),

            // ── Password Strength ─────────────────────────────────────────
            _Section(
              title: 'Password Strength',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkTextField(
                      hint: 'Enter a password…',
                      controller: _passwordController,
                      obscureText: true,
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: tokens.spaceSm),
                    SilkPasswordStrength(
                      password: _passwordController.text,
                    ),
                  ],
                ),
              ),
            ),

            // ── Receipt Card ──────────────────────────────────────────────
            _Section(
              title: 'Receipt Card',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: const SilkReceiptCard(
                  title: 'Payment summary',
                  icon: Icons.receipt_long_outlined,
                  lines: [
                    SilkReceiptLine(
                      label: 'Investment amount',
                      value: r'$2,500.00',
                    ),
                    SilkReceiptLine(
                      label: 'Processing fee',
                      value: r'$12.50',
                      muted: true,
                    ),
                    SilkReceiptLine(
                      label: 'Platform fee',
                      value: r'$5.00',
                      muted: true,
                    ),
                    SilkReceiptLine(
                      label: 'Total charged',
                      value: r'$2,517.50',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            // ── Sparkline ─────────────────────────────────────────────────
            _Section(
              title: 'Sparkline',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SilkCard(
                            hasBorder: true,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Portfolio',
                                      style: tokens.captionStyle.copyWith(
                                        color: tokens.onSurfaceMuted,
                                      ),
                                    ),
                                    Text(
                                      r'$12,480',
                                      style: tokens.titleStyle,
                                    ),
                                    Text(
                                      '+8.4%',
                                      style: tokens.captionStyle.copyWith(
                                        color: tokens.success,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SilkSparkline(
                                  data: const [
                                    9800, 10200, 9900, 11000,
                                    10800, 11500, 12480,
                                  ],
                                  color: tokens.success,
                                  height: 48,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceMd),
                    Row(
                      children: [
                        Expanded(
                          child: SilkCard(
                            hasBorder: true,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bond fund',
                                      style: tokens.captionStyle.copyWith(
                                        color: tokens.onSurfaceMuted,
                                      ),
                                    ),
                                    Text(
                                      r'$4,210',
                                      style: tokens.titleStyle,
                                    ),
                                    Text(
                                      '−1.2%',
                                      style: tokens.captionStyle.copyWith(
                                        color: tokens.danger,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SilkSparkline(
                                  data: const [
                                    4500, 4420, 4380, 4460,
                                    4300, 4250, 4210,
                                  ],
                                  color: tokens.danger,
                                  height: 48,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Donut Chart ───────────────────────────────────────────────
            _Section(
              title: 'Donut Chart',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Row(
                  children: [
                    SilkDonutChart(
                      size: 140,
                      segments: [
                        SilkDonutSegment(
                          value: 55,
                          color: tokens.accent,
                          label: 'Equities',
                        ),
                        SilkDonutSegment(
                          value: 25,
                          color: tokens.success,
                          label: 'Bonds',
                        ),
                        const SilkDonutSegment(
                          value: 12,
                          color: Color(0xFF6366F1),
                          label: 'Real estate',
                        ),
                        const SilkDonutSegment(
                          value: 8,
                          color: Color(0xFFF59E0B),
                          label: 'Cash',
                        ),
                      ],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('55%', style: tokens.titleStyle),
                          Text(
                            'equity',
                            style: tokens.captionStyle
                                .copyWith(color: tokens.onSurfaceMuted),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: tokens.spaceLg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LegendRow(
                            color: tokens.accent,
                            label: 'Equities',
                            pct: '55%',
                          ),
                          SizedBox(height: tokens.spaceSm),
                          _LegendRow(
                            color: tokens.success,
                            label: 'Bonds',
                            pct: '25%',
                          ),
                          SizedBox(height: tokens.spaceSm),
                          const _LegendRow(
                            color: Color(0xFF6366F1),
                            label: 'Real estate',
                            pct: '12%',
                          ),
                          SizedBox(height: tokens.spaceSm),
                          const _LegendRow(
                            color: Color(0xFFF59E0B),
                            label: 'Cash',
                            pct: '8%',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bar Chart ─────────────────────────────────────────────────
            _Section(
              title: 'Bar Chart',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkBarChart(
                  height: 160,
                  showValues: true,
                  entries: [
                    const SilkBarEntry(label: 'Jan', value: 4200),
                    const SilkBarEntry(label: 'Feb', value: 3800),
                    const SilkBarEntry(label: 'Mar', value: 5100),
                    SilkBarEntry(
                      label: 'Apr',
                      value: 4750,
                      color: tokens.success,
                    ),
                    const SilkBarEntry(label: 'May', value: 6200),
                    SilkBarEntry(
                      label: 'Jun',
                      value: 3200,
                      color: tokens.danger,
                    ),
                    const SilkBarEntry(label: 'Jul', value: 5900),
                  ],
                ),
              ),
            ),

            // ── Swipe to Confirm ──────────────────────────────────────────
            _Section(
              title: 'Swipe to Confirm',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkSwipeToConfirm(
                      label: 'Swipe to send ₵500',
                      onConfirmed: () =>
                          setState(() => _swipeConfirmed = true),
                    ),
                    if (_swipeConfirmed) ...[
                      SizedBox(height: tokens.spaceMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Payment confirmed!',
                            style: tokens.bodyStyle
                                .copyWith(color: tokens.success),
                          ),
                          SizedBox(width: tokens.spaceSm),
                          SilkButton(
                            label: 'Reset',
                            variant: SilkButtonVariant.ghost,
                            onPressed: () =>
                                setState(() => _swipeConfirmed = false),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Tooltip ───────────────────────────────────────────────────
            _Section(
              title: 'Tooltip',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap the info icons to reveal tooltips.',
                      style: tokens.captionStyle
                          .copyWith(color: tokens.onSurfaceMuted),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkCard(
                      hasBorder: true,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Processing fee', style: tokens.bodySmStyle),
                                  SizedBox(width: tokens.spaceXs),
                                  SilkTooltip(
                                    message:
                                        'A 0.5% fee charged by the payment processor for each transaction.',
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: tokens.onSurfaceMuted,
                                    ),
                                  ),
                                ],
                              ),
                              Text(r'$2.50', style: tokens.bodySmStyle),
                            ],
                          ),
                          SizedBox(height: tokens.spaceSm),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Platform fee', style: tokens.bodySmStyle),
                                  SizedBox(width: tokens.spaceXs),
                                  SilkTooltip(
                                    message:
                                        'Annual platform fee of 1.2% charged quarterly on invested capital.',
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: tokens.onSurfaceMuted,
                                    ),
                                  ),
                                ],
                              ),
                              Text(r'$6.00', style: tokens.bodySmStyle),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Country Picker ────────────────────────────────────────────
            _Section(
              title: 'Country Picker',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkCountryPicker(
                  label: 'Country of residence',
                  selected: _country,
                  onChanged: (c) => setState(() => _country = c),
                ),
              ),
            ),

            // ── Currency Picker ───────────────────────────────────────────
            _Section(
              title: 'Currency Picker',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkCurrencyPicker(
                  label: 'Base currency',
                  selected: _currency,
                  onChanged: (c) => setState(() => _currency = c),
                ),
              ),
            ),

            // ── Banner ────────────────────────────────────────────────────
            _Section(
              title: 'Banner',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkBanner(
                      variant: SilkBannerVariant.info,
                      title: 'KYC required',
                      body: 'Complete identity verification to unlock full access.',
                      actionLabel: 'Verify now',
                      onAction: () {},
                    ),
                    SizedBox(height: tokens.spaceSm),
                    SilkBanner(
                      variant: SilkBannerVariant.success,
                      title: 'Payment successful',
                      body: r'Your investment of $500 has been confirmed.',
                      onDismiss: () {},
                    ),
                    SizedBox(height: tokens.spaceSm),
                    const SilkBanner(
                      variant: SilkBannerVariant.warning,
                      title: 'Account limit approaching',
                      body: 'You have used 80% of your monthly transaction limit.',
                    ),
                    SizedBox(height: tokens.spaceSm),
                    const SilkBanner(
                      variant: SilkBannerVariant.danger,
                      body: 'Two-factor authentication is not enabled on your account.',
                    ),
                    SizedBox(height: tokens.spaceSm),
                    const SilkBanner(
                      variant: SilkBannerVariant.promo,
                      title: 'Refer & earn',
                      body: 'Invite a friend and earn ₵50 when they invest.',
                    ),
                  ],
                ),
              ),
            ),

            // ── Timeline ──────────────────────────────────────────────────
            _Section(
              title: 'Timeline',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: const SilkTimeline(
                  items: [
                    SilkTimelineItem(
                      title: 'Order placed',
                      subtitle: 'Payment confirmed',
                      timestamp: '09:41',
                    ),
                    SilkTimelineItem(
                      title: 'Processing',
                      subtitle: 'Preparing your items',
                      timestamp: '10:05',
                    ),
                    SilkTimelineItem(
                      title: 'Shipped',
                      status: SilkTimelineStatus.active,
                      subtitle: 'In transit — ETA tomorrow',
                      timestamp: '14:22',
                      icon: Icons.local_shipping_outlined,
                    ),
                    SilkTimelineItem(
                      title: 'Out for delivery',
                      status: SilkTimelineStatus.pending,
                    ),
                    SilkTimelineItem(
                      title: 'Delivered',
                      status: SilkTimelineStatus.pending,
                      icon: Icons.home_outlined,
                    ),
                  ],
                ),
              ),
            ),

            // ── Pin Dots ──────────────────────────────────────────────────
            _Section(
              title: 'Pin Dots',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkPinDots(
                      length: 4,
                      filled: _pinFilled,
                      hasError: _pinError,
                    ),
                    SizedBox(height: tokens.spaceLg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SilkButton(
                          label: 'Fill',
                          variant: SilkButtonVariant.secondary,
                          onPressed: _pinFilled < 4
                              ? () => setState(() {
                                    _pinFilled++;
                                    _pinError = false;
                                  })
                              : null,
                        ),
                        SizedBox(width: tokens.spaceSm),
                        SilkButton(
                          label: 'Clear',
                          variant: SilkButtonVariant.secondary,
                          onPressed: _pinFilled > 0
                              ? () => setState(() {
                                    _pinFilled--;
                                    _pinError = false;
                                  })
                              : null,
                        ),
                        SizedBox(width: tokens.spaceSm),
                        SilkButton(
                          label: 'Error',
                          variant: SilkButtonVariant.destructive,
                          onPressed: () =>
                              setState(() => _pinError = true),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Sort & Filter Bar ─────────────────────────────────────────
            _Section(
              title: 'Sort & Filter Bar',
              child: SilkSortFilterBar<String>(
                filters: const [
                  SilkFilterChip(value: 'all', label: 'All'),
                  SilkFilterChip(value: 'credit', label: 'Credits'),
                  SilkFilterChip(value: 'debit', label: 'Debits'),
                  SilkFilterChip(value: 'pending', label: 'Pending'),
                  SilkFilterChip(value: 'failed', label: 'Failed'),
                ],
                selected: _sortFilter,
                onSelected: (v) => setState(() => _sortFilter = v),
                onSortTap: () =>
                    setState(() => _sortActive = !_sortActive),
                sortActive: _sortActive,
              ),
            ),

            // ── Rating ────────────────────────────────────────────────────
            _Section(
              title: 'Rating',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SilkRating(
                          value: _rating,
                          onChanged: (v) =>
                              setState(() => _rating = v),
                        ),
                        SizedBox(width: tokens.spaceMd),
                        Text(
                          _rating.toStringAsFixed(1),
                          style: tokens.bodyStyle
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceMd),
                    Row(
                      children: [
                        const SilkRating(value: 4.5),
                        SizedBox(width: tokens.spaceSm),
                        Text(
                          '4.5 · read-only with half star',
                          style: tokens.captionStyle
                              .copyWith(color: tokens.onSurfaceMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Action Sheet ──────────────────────────────────────────────
            _Section(
              title: 'Action Sheet',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkButton(
                  label: 'Open action sheet',
                  variant: SilkButtonVariant.secondary,
                  onPressed: () => unawaited(
                    SilkActionSheet.show(
                      context: context,
                      title: 'Transaction options',
                      message:
                          'What would you like to do with this transaction?',
                      actions: [
                        SilkActionItem(
                          label: 'Download receipt',
                          icon: Icons.download_outlined,
                          onTap: () {},
                        ),
                        SilkActionItem(
                          label: 'Share transaction',
                          icon: Icons.share_outlined,
                          onTap: () {},
                        ),
                        SilkActionItem(
                          label: 'Report an issue',
                          icon: Icons.flag_outlined,
                          onTap: () {},
                        ),
                        SilkActionItem(
                          label: 'Reverse transaction',
                          icon: Icons.undo_outlined,
                          isDestructive: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Dialog ────────────────────────────────────────────────────
            _Section(
              title: 'Dialog',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Wrap(
                  spacing: tokens.spaceSm,
                  runSpacing: tokens.spaceSm,
                  children: [
                    SilkButton(
                      label: 'Confirm',
                      variant: SilkButtonVariant.secondary,
                      onPressed: () => unawaited(
                        SilkDialog.confirm(
                          context: context,
                          title: 'Withdraw funds',
                          message:
                              r'Are you sure you want to withdraw $500 from your account?',
                          confirmLabel: 'Withdraw',
                        ),
                      ),
                    ),
                    SilkButton(
                      label: 'Destructive',
                      variant: SilkButtonVariant.secondary,
                      onPressed: () => unawaited(
                        SilkDialog.confirm(
                          context: context,
                          title: 'Delete account',
                          message:
                              'This action is permanent and cannot be undone. All your data will be deleted.',
                          confirmLabel: 'Delete account',
                          isDestructive: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Buttons ────────────────────────────────────────────────────
            _Section(title: 'Buttons', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: Wrap(
                spacing: tokens.spaceSm,
                runSpacing: tokens.spaceSm,
                children: [
                  SilkButton(label: 'Primary', onPressed: () {}),
                  SilkButton(
                    label: 'Secondary',
                    variant: SilkButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  SilkButton(
                    label: 'Ghost',
                    variant: SilkButtonVariant.ghost,
                    onPressed: () {},
                  ),
                  SilkButton(
                    label: 'Destructive',
                    variant: SilkButtonVariant.destructive,
                    onPressed: () {},
                  ),
                  const SilkButton(
                    label: 'Loading',
                    onPressed: null,
                    isLoading: true,
                  ),
                  const SilkButton(
                    label: 'Disabled',
                    onPressed: null,
                  ),
                  SilkButton(
                    label: 'With icon',
                    onPressed: () {},
                    icon: const Icon(Icons.send_outlined),
                  ),
                ],
              ),
            )),

            // ── Icon Buttons ───────────────────────────────────────────────
            _Section(title: 'Icon Buttons', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: tokens.spaceSm,
                    runSpacing: tokens.spaceSm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SilkIconButton(
                        icon: Icons.add,
                        onPressed: () {},
                        variant: SilkIconButtonVariant.primary,
                      ),
                      SilkIconButton(
                        icon: Icons.add,
                        onPressed: () {},
                        variant: SilkIconButtonVariant.ghost,
                      ),
                      SilkIconButton(
                        icon: Icons.add,
                        onPressed: () {},
                        variant: SilkIconButtonVariant.subtle,
                      ),
                      SilkIconButton(
                        icon: Icons.delete_outline,
                        onPressed: () {},
                        variant: SilkIconButtonVariant.destructive,
                      ),
                    ],
                  ),
                  SizedBox(height: tokens.spaceSm),
                  Wrap(
                    spacing: tokens.spaceSm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SilkIconButton(
                        icon: Icons.star_outline,
                        onPressed: () {},
                        size: SilkIconButtonSize.sm,
                      ),
                      SilkIconButton(
                        icon: Icons.star_outline,
                        onPressed: () {},
                        size: SilkIconButtonSize.md,
                      ),
                      SilkIconButton(
                        icon: Icons.star_outline,
                        onPressed: () {},
                        size: SilkIconButtonSize.lg,
                      ),
                    ],
                  ),
                ],
              ),
            )),

            // ── Text Field ─────────────────────────────────────────────────
            _Section(title: 'Text Field', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: SilkTextField(
                hint: 'Type something…',
                controller: _textController,
                textInputAction: TextInputAction.done,
              ),
            )),

            // ── Dropdown ───────────────────────────────────────────────────
            _Section(title: 'Dropdown', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: SilkDropdown<String>(
                items: _countries,
                value: _dropdownValue,
                label: 'Country',
                hint: 'Select a country',
                onChanged: (v) => setState(() => _dropdownValue = v),
              ),
            )),

            // ── Multi-select ───────────────────────────────────────────────
            _Section(title: 'Multi-select', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: SilkMultiValueSelectInput<String>(
                items: _countries,
                selectedValues: _multiValues,
                label: 'Countries visited',
                hint: 'Select countries',
                onChanged: (v) => setState(() => _multiValues = v),
              ),
            )),

            // ── Date Picker ────────────────────────────────────────────────
            _Section(title: 'Date Picker', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: SilkDatePicker(
                selectedDate: _date,
                label: 'Date',
                onChanged: (d) => setState(() => _date = d),
              ),
            )),

            // ── Time Picker ────────────────────────────────────────────────
            _Section(title: 'Time Picker', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: SilkTimePicker(
                selectedTime: _time,
                label: 'Time',
                onChanged: (t) => setState(() => _time = t),
              ),
            )),

            // ── Date & Time Picker ─────────────────────────────────────────
            _Section(title: 'Date & Time Picker', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: SilkDateTimePicker(
                selectedDateTime: _dateTime,
                label: 'Scheduled at',
                onChanged: (dt) => setState(() => _dateTime = dt),
              ),
            )),

            // ── Calendar ───────────────────────────────────────────────────
            _Section(title: 'Calendar', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: SilkCalendar(
                selectedDate: _calendarDate,
                highlightedDates: [
                  DateTime.now().add(const Duration(days: 3)),
                  DateTime.now().add(const Duration(days: 7)),
                  DateTime.now().add(const Duration(days: 12)),
                ],
                onDateSelected: (d) => setState(() => _calendarDate = d),
              ),
            )),

            // ── Avatars ────────────────────────────────────────────────────
            _Section(title: 'Avatars', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: Wrap(
                spacing: tokens.spaceMd,
                runSpacing: tokens.spaceMd,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const SilkAvatar(size: 56, initials: 'AS'),
                  SilkAvatar(
                    size: 56,
                    initials: 'BH',
                    color: tokens.success,
                  ),
                  const SilkAvatar(size: 40, initials: 'CK'),
                  const SilkAvatar(size: 32, initials: 'DM'),
                  const Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SilkAvatar(size: 56, initials: 'EF'),
                      Positioned(
                        right: -2,
                        top: -2,
                        child: SilkBadge.count(count: 5),
                      ),
                    ],
                  ),
                ],
              ),
            )),

            // ── Badges ─────────────────────────────────────────────────────
            _Section(title: 'Badges', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: Wrap(
                spacing: tokens.spaceSm,
                runSpacing: tokens.spaceSm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  SilkBadge(label: 'Accent'),
                  SilkBadge(label: 'Success', variant: SilkBadgeVariant.success),
                  SilkBadge(label: 'Danger', variant: SilkBadgeVariant.danger),
                  SilkBadge(label: 'Muted', variant: SilkBadgeVariant.muted),
                  SilkBadge.count(count: 99),
                ],
              ),
            )),

            // ── List Tiles ─────────────────────────────────────────────────
            _Section(title: 'List Tiles', child: Column(
              children: [
                SilkListTile(
                  leading: Icon(Icons.person_outline,
                      color: context.tokens.onSurfaceMuted),
                  title: Text('Profile', style: tokens.bodyStyle),
                  subtitle: Text('Edit your information',
                      style: tokens.captionStyle
                          .copyWith(color: tokens.onSurfaceMuted)),
                  trailing: Icon(Icons.chevron_right,
                      color: tokens.onSurfaceMuted),
                  onTap: () {},
                ),
                SilkListTile(
                  leading: Icon(Icons.notifications_outlined,
                      color: context.tokens.onSurfaceMuted),
                  title: Text('Notifications', style: tokens.bodyStyle),
                  trailing: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.chevron_right, color: tokens.onSurfaceMuted),
                      const Positioned(
                        right: 18,
                        top: 0,
                        child: SilkBadge.count(count: 3),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
                const _AppearanceTile(),
                SilkListTile(
                  leading: Icon(Icons.delete_outline, color: tokens.danger),
                  title: Text(
                    'Delete account',
                    style: tokens.bodyStyle.copyWith(color: tokens.danger),
                  ),
                  showDivider: false,
                  onTap: () {},
                ),
              ],
            )),

            // ── Bottom Sheet ───────────────────────────────────────────────
            _Section(title: 'Bottom Sheet', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: SilkButton(
                label: 'Open bottom sheet',
                variant: SilkButtonVariant.secondary,
                onPressed: () => unawaited(
                  SilkBottomSheet.show(
                    context: context,
                    title: 'Example sheet',
                    child: Padding(
                      padding: EdgeInsets.all(tokens.spaceLg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Bottom sheets slide up with a spring animation and can contain any content.',
                            style: tokens.bodyStyle
                                .copyWith(color: tokens.onSurfaceMuted),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: tokens.spaceLg),
                          SilkButton(
                            label: 'Got it',
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          SizedBox(height: tokens.spaceMd),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),

            // ── Context Menu ───────────────────────────────────────────────
            _Section(title: 'Context Menu (long press)', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: SilkContextMenu(
                items: [
                  SilkContextMenuItem(
                    label: 'Copy',
                    icon: Icons.copy_outlined,
                    onTap: () {},
                  ),
                  SilkContextMenuItem(
                    label: 'Share',
                    icon: Icons.share_outlined,
                    onTap: () {},
                  ),
                  SilkContextMenuItem(
                    label: 'Delete',
                    icon: Icons.delete_outline,
                    onTap: () {},
                    isDestructive: true,
                  ),
                ],
                child: Container(
                  decoration: BoxDecoration(
                    color: tokens.surfaceMuted,
                    borderRadius: BorderRadius.circular(tokens.radiusMd),
                    border: Border.all(color: tokens.divider),
                  ),
                  padding: EdgeInsets.all(tokens.spaceMd),
                  child: Row(
                    children: [
                      Icon(Icons.touch_app_outlined,
                          color: tokens.onSurfaceMuted, size: 18),
                      SizedBox(width: tokens.spaceSm),
                      Text(
                        'Long-press me for a context menu',
                        style: tokens.bodyStyle
                            .copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ],
                  ),
                ),
              ),
            )),

            // ── Reaction Burst ─────────────────────────────────────────────
            _Section(
              title: 'Reaction Burst',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap any reaction — particles burst from the Overlay.',
                      style: tokens.captionStyle
                          .copyWith(color: tokens.onSurfaceMuted),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: tokens.spaceMd,
                        vertical: tokens.spaceSm,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.surfaceMuted,
                        borderRadius:
                            BorderRadius.circular(tokens.radiusPill),
                        border: Border.all(color: tokens.divider),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _ReactionChip(
                            emoji: '❤️',
                            count: 24,
                            color: Color(0xFFE0245E),
                          ),
                          SizedBox(width: tokens.spaceXs),
                          _ReactionChip(
                            emoji: '👍',
                            count: 142,
                            color: tokens.accent,
                          ),
                          SizedBox(width: tokens.spaceXs),
                          const _ReactionChip(
                            emoji: '😂',
                            count: 8,
                            color: Color(0xFFF7B731),
                          ),
                          SizedBox(width: tokens.spaceXs),
                          const _ReactionChip(
                            emoji: '🔥',
                            count: 3,
                            color: Color(0xFFFF6348),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Search Bar ────────────────────────────────────────────────
            _Section(
              title: 'Search Bar',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkSearchBar(
                  controller: _searchController,
                  placeholder: 'Search anything…',
                ),
              ),
            ),

            // ── Switch ─────────────────────────────────────────────────────
            _Section(
              title: 'Switch',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SilkSwitch(
                          value: _switchOn,
                          onChanged: (v) => setState(() => _switchOn = v),
                        ),
                        SizedBox(width: tokens.spaceMd),
                        Text(
                          _switchOn ? 'On' : 'Off',
                          style: tokens.bodyStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceSm),
                    Row(
                      children: [
                        const SilkSwitch(value: false, onChanged: null),
                        SizedBox(width: tokens.spaceMd),
                        Text(
                          'Disabled',
                          style: tokens.bodyStyle
                              .copyWith(color: tokens.onSurfaceMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Checkbox ───────────────────────────────────────────────────
            _Section(
              title: 'Checkbox',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SilkCheckbox(
                      value: _checkboxA,
                      label: 'Accept terms & conditions',
                      onChanged: (v) => setState(() => _checkboxA = v),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    SilkCheckbox(
                      value: _checkboxB,
                      label: 'Receive marketing emails',
                      onChanged: (v) => setState(() => _checkboxB = v),
                    ),
                    SizedBox(height: tokens.spaceMd),
                    const SilkCheckbox(
                      value: false,
                      label: 'Disabled option',
                      onChanged: null,
                    ),
                  ],
                ),
              ),
            ),

            // ── Segmented Control ──────────────────────────────────────────
            _Section(
              title: 'Segmented Control',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkSegmentedControl<String>(
                  selected: _segment,
                  onSelected: (v) => setState(() => _segment = v),
                  segments: const [
                    SilkSegment(value: 'day', label: 'Day'),
                    SilkSegment(value: 'week', label: 'Week'),
                    SilkSegment(value: 'month', label: 'Month'),
                    SilkSegment(value: 'year', label: 'Year'),
                  ],
                ),
              ),
            ),

            // ── Radio Group ────────────────────────────────────────────────
            _Section(
              title: 'Radio Group',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkRadioGroup<String>(
                  selected: _radioValue,
                  onSelected: (v) => setState(() => _radioValue = v),
                  options: const [
                    SilkRadioOption(
                      value: 'free',
                      label: 'Free',
                      description: 'Up to 3 projects',
                    ),
                    SilkRadioOption(
                      value: 'pro',
                      label: 'Pro',
                      description: r'$9/month · unlimited projects',
                    ),
                    SilkRadioOption(
                      value: 'team',
                      label: 'Team',
                      description: r'$29/month · team collaboration',
                    ),
                  ],
                ),
              ),
            ),

            // ── Chips ──────────────────────────────────────────────────────
            _Section(
              title: 'Chips',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Wrap(
                  spacing: tokens.spaceSm,
                  runSpacing: tokens.spaceSm,
                  children: [
                    SilkChip(label: 'Default', onTap: () {}),
                    SilkChip(label: 'Selected', selected: true, onTap: () {}),
                    SilkChip(
                      label: 'With icon',
                      leadingIcon: Icons.tag,
                      onTap: () {},
                    ),
                    SilkChip(
                      label: 'Deletable',
                      onDelete: () {},
                      onTap: () {},
                    ),
                    const SilkChip(label: 'Disabled'),
                  ],
                ),
              ),
            ),

            // ── Divider ────────────────────────────────────────────────────
            _Section(
              title: 'Divider',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    const SilkDivider(),
                    SizedBox(height: tokens.spaceMd),
                    const SilkDivider(label: 'or continue with'),
                    SizedBox(height: tokens.spaceMd),
                    const SilkDivider(label: 'Today'),
                  ],
                ),
              ),
            ),

            // ── Progress Bar ───────────────────────────────────────────────
            _Section(
              title: 'Progress Bar',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkProgressBar(
                      value: _progressValue,
                      label: 'Upload progress',
                    ),
                    SizedBox(height: tokens.spaceMd),
                    const SilkProgressBar(
                      value: 0.7,
                      variant: SilkProgressBarVariant.success,
                    ),
                    SizedBox(height: tokens.spaceMd),
                    const SilkProgressBar(
                      value: 0.45,
                      variant: SilkProgressBarVariant.danger,
                    ),
                    SizedBox(height: tokens.spaceMd),
                    Row(
                      children: [
                        Expanded(
                          child: SilkProgressBar(value: _progressValue),
                        ),
                        SizedBox(width: tokens.spaceSm),
                        SilkIconButton(
                          icon: Icons.remove,
                          size: SilkIconButtonSize.sm,
                          onPressed: _progressValue > 0
                              ? () => setState(
                                    () => _progressValue =
                                        (_progressValue - 0.1).clamp(0.0, 1.0),
                                  )
                              : null,
                        ),
                        SilkIconButton(
                          icon: Icons.add,
                          size: SilkIconButtonSize.sm,
                          onPressed: _progressValue < 1
                              ? () => setState(
                                    () => _progressValue =
                                        (_progressValue + 0.1).clamp(0.0, 1.0),
                                  )
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Stepper ────────────────────────────────────────────────────
            _Section(
              title: 'Stepper',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vertical
                    SilkStepper(
                      currentStep: _stepperStep,
                      onStepTap: (i) => setState(() => _stepperStep = i),
                      steps: const [
                        SilkStep(
                          label: 'Order placed',
                          description: 'We received your order.',
                        ),
                        SilkStep(
                          label: 'Processing',
                          description: 'Payment confirmed, preparing items.',
                        ),
                        SilkStep(label: 'Shipped'),
                        SilkStep(label: 'Delivered'),
                      ],
                    ),
                    SizedBox(height: tokens.spaceLg),
                    // Controls
                    Row(
                      children: [
                        SilkButton(
                          label: 'Back',
                          variant: SilkButtonVariant.secondary,
                          onPressed: _stepperStep > 0
                              ? () => setState(() => _stepperStep--)
                              : null,
                        ),
                        SizedBox(width: tokens.spaceSm),
                        SilkButton(
                          label: 'Next',
                          onPressed: _stepperStep < 3
                              ? () => setState(() => _stepperStep++)
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceLg),
                    // Horizontal
                    SilkStepper(
                      axis: Axis.horizontal,
                      currentStep: _stepperStep,
                      onStepTap: (i) => setState(() => _stepperStep = i),
                      steps: const [
                        SilkStep(label: 'Placed'),
                        SilkStep(label: 'Processing'),
                        SilkStep(label: 'Shipped'),
                        SilkStep(label: 'Delivered'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Empty State ────────────────────────────────────────────────
            _Section(
              title: 'Empty State',
              child: SilkEmptyState(
                icon: Icons.inbox_outlined,
                title: 'Nothing here yet',
                body: "When you add items they'll appear here.",
                actionLabel: 'Add your first item',
                onAction: () {},
              ),
            ),

            // ── Toast ──────────────────────────────────────────────────────
            _Section(
              title: 'Toast',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Wrap(
                  spacing: tokens.spaceSm,
                  runSpacing: tokens.spaceSm,
                  children: [
                    SilkButton(
                      label: 'Success',
                      variant: SilkButtonVariant.secondary,
                      onPressed: () => SilkToast.show(
                        context,
                        'Changes saved successfully.',
                        variant: SilkToastVariant.success,
                      ),
                    ),
                    SilkButton(
                      label: 'Error',
                      variant: SilkButtonVariant.secondary,
                      onPressed: () => SilkToast.show(
                        context,
                        'Something went wrong. Try again.',
                        variant: SilkToastVariant.error,
                      ),
                    ),
                    SilkButton(
                      label: 'Warning',
                      variant: SilkButtonVariant.secondary,
                      onPressed: () => SilkToast.show(
                        context,
                        'Your session expires in 5 minutes.',
                        variant: SilkToastVariant.warning,
                      ),
                    ),
                    SilkButton(
                      label: 'Info',
                      variant: SilkButtonVariant.secondary,
                      onPressed: () => SilkToast.show(
                        context,
                        'New version available. Restart to update.',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Skeleton ───────────────────────────────────────────────────
            _Section(
              title: 'Skeleton',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    const SilkSkeleton.listItem(),
                    SizedBox(height: tokens.spaceMd),
                    const SilkSkeleton.listItem(),
                    SizedBox(height: tokens.spaceMd),
                    const SilkSkeleton.text(lines: 4),
                    SizedBox(height: tokens.spaceMd),
                    const SilkSkeleton.card(),
                  ],
                ),
              ),
            ),

            // ── Bottom Nav Bar ─────────────────────────────────────────────
            _Section(
              title: 'Bottom Nav Bar',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(tokens.radiusLg),
                  child: SilkBottomNavBar(
                    currentIndex: _navIndex,
                    onTap: (i) => setState(() => _navIndex = i),
                    items: const [
                      SilkNavItem(icon: Icons.home_outlined, label: 'Home'),
                      SilkNavItem(
                        icon: Icons.explore_outlined,
                        label: 'Explore',
                      ),
                      SilkNavItem(
                        icon: Icons.notifications_outlined,
                        label: 'Alerts',
                      ),
                      SilkNavItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Shimmer ────────────────────────────────────────────────────
            _Section(title: 'Shimmer / Loading', child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SilkShimmer(width: 48, height: 48, borderRadius: 24),
                      SizedBox(width: tokens.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SilkShimmer(
                              width: double.infinity,
                              height: 14,
                              borderRadius: tokens.radiusSm,
                            ),
                            SizedBox(height: tokens.spaceXs),
                            SilkShimmer(
                              width: 140,
                              height: 12,
                              borderRadius: tokens.radiusSm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: tokens.spaceMd),
                  Row(
                    children: [
                      const SilkShimmer(width: 48, height: 48, borderRadius: 24),
                      SizedBox(width: tokens.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SilkShimmer(
                              width: double.infinity,
                              height: 14,
                              borderRadius: tokens.radiusSm,
                            ),
                            SizedBox(height: tokens.spaceXs),
                            SilkShimmer(
                              width: 100,
                              height: 12,
                              borderRadius: tokens.radiusSm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: tokens.spaceMd),
                  SilkShimmer(
                    width: double.infinity,
                    height: 120,
                    borderRadius: tokens.radiusMd,
                  ),
                ],
              ),
            )),

            // ── Stat Card ──────────────────────────────────────────────────
            _Section(
              title: 'Stat Card',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    const SilkStatCard(
                      label: 'Total Portfolio',
                      value: r'$12,480',
                      delta: 8.4,
                      deltaLabel: 'vs last month',
                      icon: Icons.account_balance_wallet_outlined,
                      sparklineData: [9800, 10200, 10800, 11400, 12480],
                    ),
                    SizedBox(height: tokens.spaceSm),
                    const SilkStatCard(
                      label: 'Fixed Income',
                      value: r'$3,100',
                      delta: -2.1,
                      deltaLabel: 'vs last month',
                      icon: Icons.trending_down_outlined,
                      sparklineData: [3400, 3300, 3200, 3150, 3100],
                    ),
                  ],
                ),
              ),
            ),

            // ── Toggle Card ────────────────────────────────────────────────
            _Section(
              title: 'Toggle Card',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkToggleCard(
                      title: 'Basic',
                      description: 'Free · up to 2 projects',
                      icon: Icons.layers_outlined,
                      selected: _plan == 'basic',
                      onTap: () => setState(() => _plan = 'basic'),
                    ),
                    SizedBox(height: tokens.spaceSm),
                    SilkToggleCard(
                      title: 'Pro',
                      description: r'$9 / month · unlimited projects',
                      icon: Icons.rocket_launch_outlined,
                      selected: _plan == 'pro',
                      onTap: () => setState(() => _plan = 'pro'),
                    ),
                    SizedBox(height: tokens.spaceSm),
                    SilkToggleCard(
                      title: 'Enterprise',
                      description: 'Custom pricing · team features',
                      icon: Icons.business_outlined,
                      selected: _plan == 'enterprise',
                      onTap: () => setState(() => _plan = 'enterprise'),
                    ),
                  ],
                ),
              ),
            ),

            // ── Accordion ──────────────────────────────────────────────────
            _Section(
              title: 'Accordion',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkAccordion(
                  initialIndex: 0,
                  items: [
                    SilkAccordionItem(
                      title: 'What is APY?',
                      icon: Icons.percent_outlined,
                      child: Text(
                        'Annual Percentage Yield (APY) reflects total interest earned in one year, including compound interest.',
                        style: tokens.bodySmStyle
                            .copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ),
                    SilkAccordionItem(
                      title: 'When do I get paid?',
                      icon: Icons.schedule_outlined,
                      child: Text(
                        'Interest is credited on the first business day of each month. Withdrawals settle within 2 business days.',
                        style: tokens.bodySmStyle
                            .copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ),
                    SilkAccordionItem(
                      title: 'Is my money insured?',
                      icon: Icons.shield_outlined,
                      child: Text(
                        'Deposits are protected up to GH₵100,000 per depositor by the Ghana Deposit Protection Corporation.',
                        style: tokens.bodySmStyle
                            .copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Line Chart ─────────────────────────────────────────────────
            _Section(
              title: 'Line Chart',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkLineChart(
                  series: [
                    SilkLineSeries(
                      label: 'Portfolio',
                      data: const [9800, 10200, 11000, 10800, 12480, 13100],
                      color: tokens.accent,
                    ),
                    SilkLineSeries(
                      label: 'Benchmark',
                      data: const [10000, 10100, 10300, 10500, 10900, 11200],
                      color: tokens.onSurfaceMuted,
                      filled: false,
                    ),
                  ],
                  xLabels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                  height: 200,
                ),
              ),
            ),

            // ── Table View ─────────────────────────────────────────────────
            _Section(
              title: 'Table View',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: const SilkTableView(
                  columns: [
                    SilkTableColumn(label: 'Asset', flex: 2),
                    SilkTableColumn(
                      label: 'Value',
                      numeric: true,
                      alignment: TextAlign.right,
                    ),
                    SilkTableColumn(
                      label: 'Return',
                      numeric: true,
                      alignment: TextAlign.right,
                    ),
                  ],
                  rows: [
                    ['Equities', r'$8,200', '+12.4%'],
                    ['Bonds', r'$3,100', '+4.1%'],
                    ['Cash', r'$1,180', '+1.8%'],
                    ['Alternatives', r'$2,400', '-2.3%'],
                  ],
                ),
              ),
            ),

            // ── Month Picker ───────────────────────────────────────────────
            _Section(
              title: 'Month Picker',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkMonthPicker(
                  label: 'Report period',
                  value: _reportMonth,
                  onChanged: (m) => setState(() => _reportMonth = m),
                ),
              ),
            ),

            // ── Number Range Picker ────────────────────────────────────────
            _Section(
              title: 'Number Range Picker',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkNumberRangePicker(
                  label: 'Investment range',
                  min: 0,
                  max: 10000,
                  start: _rangeStart,
                  end: _rangeEnd,
                  valueFormatter: (v) => 'GH₵${v.toStringAsFixed(0)}',
                  onChanged: (s, e) => setState(() {
                    _rangeStart = s;
                    _rangeEnd = e;
                  }),
                ),
              ),
            ),

            // ── Text Area ──────────────────────────────────────────────────
            _Section(
              title: 'Text Area',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkTextArea(
                  controller: _textAreaController,
                  label: 'Investment notes',
                  hint: 'Add notes about your strategy…',
                  maxLength: 500,
                  minLines: 4,
                ),
              ),
            ),

            // ── Signature Pad ──────────────────────────────────────────────
            _Section(
              title: 'Signature Pad',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SilkSignaturePad(controller: _sigCtrl),
                    SizedBox(height: tokens.spaceSm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _sigCtrl.clear,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Clear'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Step Wizard ────────────────────────────────────────────────
            _Section(
              title: 'Step Wizard',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkStepWizard(
                  steps: [
                    SilkWizardStep(
                      title: 'Personal info',
                      child: Text(
                        'Enter your full name, date of birth, and contact details to get started.',
                        style: tokens.bodySmStyle
                            .copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ),
                    SilkWizardStep(
                      title: 'Identity document',
                      child: Text(
                        "Upload a valid national ID, passport, or driver's licence for KYC verification.",
                        style: tokens.bodySmStyle
                            .copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ),
                    SilkWizardStep(
                      title: 'Review & Submit',
                      child: Text(
                        'Review your details carefully before submitting your application.',
                        style: tokens.bodySmStyle
                            .copyWith(color: tokens.onSurfaceMuted),
                      ),
                    ),
                  ],
                  onFinish: () => SilkToast.show(
                    context,
                    'Application submitted!',
                    variant: SilkToastVariant.success,
                  ),
                ),
              ),
            ),
            // ── Pie Chart (3D) ─────────────────────────────────────────────
            _Section(
              title: '3D Pie Chart',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Row(
                  children: [
                    SilkPieChart(
                      size: 180,
                      selectedIndex: _pieSelectedIndex,
                      onSegmentTap: (i) =>
                          setState(() => _pieSelectedIndex = i == _pieSelectedIndex ? null : i),
                      segments: const [
                        SilkPieSegment(value: 52, color: Color(0xFF6366F1), label: 'Equities'),
                        SilkPieSegment(value: 24, color: Color(0xFF22C55E), label: 'Bonds'),
                        SilkPieSegment(value: 14, color: Color(0xFFF59E0B), label: 'Cash'),
                        SilkPieSegment(value: 10, color: Color(0xFFEC4899), label: 'Alts'),
                      ],
                    ),
                    SizedBox(width: tokens.spaceLg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tap a slice to pop it out', style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted)),
                          SizedBox(height: tokens.spaceSm),
                          const _LegendRow(color: Color(0xFF6366F1), label: 'Equities', pct: '52%'),
                          const _LegendRow(color: Color(0xFF22C55E), label: 'Bonds', pct: '24%'),
                          const _LegendRow(color: Color(0xFFF59E0B), label: 'Cash', pct: '14%'),
                          const _LegendRow(color: Color(0xFFEC4899), label: 'Alternatives', pct: '10%'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Gauge Chart ────────────────────────────────────────────────
            _Section(
              title: 'Gauge Chart',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SilkGaugeChart(
                      value: 74,
                      label: 'Risk score',
                      size: 160,
                      gradientColors: [tokens.success, tokens.accent],
                    ),
                    SilkGaugeChart(
                      value: 38,
                      label: 'Portfolio health',
                      size: 160,
                      gradientColors: [tokens.danger, const Color(0xFFF59E0B)],
                    ),
                  ],
                ),
              ),
            ),

            // ── Heatmap ────────────────────────────────────────────────────
            _Section(
              title: 'Heatmap',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: SilkHeatmap(
                  fillColor: tokens.accent,
                  data: List.generate(
                    18 * 7,
                    (i) => SilkHeatmapDay(
                      date: DateTime.now().subtract(
                        Duration(days: 18 * 7 - 1 - i),
                      ),
                      value: (i % 7 == 0 || i % 11 == 0)
                          ? 0
                          : ((i % 5) + 1).toDouble(),
                    ),
                  ),
                ),
              ),
            ),

            // ── Chat Bubble ────────────────────────────────────────────────
            _Section(
              title: 'Chat Bubble',
              child: Column(
                children: [
                  const SilkChatBubble(
                    message: 'Your portfolio is up 8.4% this month 🎉',
                    side: SilkChatSide.receiver,
                    timestamp: '09:41',
                  ),
                  SilkChatBubble(
                    message: 'Should I rebalance into bonds now?',
                    side: SilkChatSide.sender,
                    timestamp: '09:42',
                    statusIcon: Icon(Icons.done_all_rounded, size: 12, color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  const SilkChatBubble(
                    message: 'With rates where they are, a small shift into short-duration bonds makes sense. Shall I model the impact?',
                    side: SilkChatSide.receiver,
                    timestamp: '09:43',
                  ),
                ],
              ),
            ),

            // ── Floating Label Input ────────────────────────────────────────
            _Section(
              title: 'Floating Label Input',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkFloatingLabelInput(
                      label: 'Account number',
                      controller: _floatingInputCtrl,
                      hint: 'e.g. 1234567890',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: tokens.spaceMd),
                    const SilkFloatingLabelInput(
                      label: 'PIN',
                      obscureText: true,
                      errorText: 'PIN must be 4 digits',
                    ),
                  ],
                ),
              ),
            ),

            // ── File Upload Zone ───────────────────────────────────────────
            _Section(
              title: 'File Upload Zone',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: Column(
                  children: [
                    SilkFileUploadZone(
                      fileName: _uploadFileName,
                      fileSize: _uploadFileName != null ? '1.2 MB' : null,
                      hint: 'Tap to upload your ID document',
                      acceptLabel: 'PDF, JPG, PNG up to 5MB',
                      onTap: () => setState(
                        () => _uploadFileName = 'national_id.pdf',
                      ),
                      onClear: _uploadFileName != null
                          ? () => setState(() => _uploadFileName = null)
                          : null,
                    ),
                  ],
                ),
              ),
            ),

            // ── Markdown Text ──────────────────────────────────────────────
            _Section(
              title: 'Markdown Text',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
                child: const SilkMarkdownText(
                  data: '''
## Portfolio Summary

Your **Q2 2026** performance was *exceptional*:

- Total return: **+12.4%**
- Best asset: `Equities`
- Worst asset: `Alternatives`

---

Review your allocation before the Q3 rebalance window opens.
''',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Appearance tile ────────────────────────────────────────────────────────

class _AppearanceTile extends ConsumerWidget {
  const _AppearanceTile();

  static const _modes = [
    (ThemeMode.system, 'System', Icons.brightness_auto_outlined),
    (ThemeMode.light, 'Light', Icons.light_mode_outlined),
    (ThemeMode.dark, 'Dark', Icons.dark_mode_outlined),
  ];

  String _label(ThemeMode mode) =>
      _modes.firstWhere((m) => m.$1 == mode).$2;

  IconData _icon(ThemeMode mode) =>
      _modes.firstWhere((m) => m.$1 == mode).$3;

  Future<void> _showPicker(BuildContext context, ThemeMode current) async {
    await SilkBottomSheet.show<void>(
      context: context,
      title: 'Appearance',
      child: Consumer(
        builder: (ctx, ref, _) {
          final tokens = ctx.tokens;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (mode, label, icon) in _modes)
                SilkListTile(
                  leading: Icon(icon, color: tokens.onSurfaceMuted),
                  title: Text(label, style: tokens.bodyStyle),
                  trailing: current == mode
                      ? Icon(Icons.check, color: tokens.accent)
                      : null,
                  showDivider: mode != ThemeMode.dark,
                  onTap: () {
                    ref
                        .read(themeModeNotifierProvider.notifier)
                        .setMode(mode);
                    Navigator.of(ctx).pop();
                  },
                ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final current = ref.watch(themeModeNotifierProvider).valueOrNull
        ?? ThemeMode.system;

    return SilkListTile(
      leading: Icon(_icon(current), color: tokens.onSurfaceMuted),
      title: Text('Appearance', style: tokens.bodyStyle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _label(current),
            style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: tokens.onSurfaceMuted),
        ],
      ),
      onTap: () => _showPicker(context, current),
    );
  }
}

// ─── Reaction chip ──────────────────────────────────────────────────────────

class _ReactionChip extends StatefulWidget {
  const _ReactionChip({
    required this.emoji,
    required this.count,
    required this.color,
  });

  final String emoji;
  final int count;
  final Color color;

  @override
  State<_ReactionChip> createState() => _ReactionChipState();
}

class _ReactionChipState extends State<_ReactionChip> {
  int _count = 0;
  bool _reacted = false;

  @override
  void initState() {
    super.initState();
    _count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SilkReactionBurst(
      color: widget.color,
      onTap: () => setState(() {
        if (_reacted) {
          _count--;
        } else {
          _count++;
        }
        _reacted = !_reacted;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spaceSm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: _reacted
              ? widget.color.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(tokens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              transitionBuilder: (child, anim) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Text(
                '$_count',
                key: ValueKey(_count),
                style: tokens.captionStyle.copyWith(
                  color: _reacted ? widget.color : tokens.onSurfaceMuted,
                  fontWeight:
                      _reacted ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Donut chart legend row ─────────────────────────────────────────────────

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.pct,
  });

  final Color color;
  final String label;
  final String pct;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: tokens.spaceXs),
        Expanded(
          child: Text(
            label,
            style: tokens.captionStyle,
          ),
        ),
        Text(
          pct,
          style: tokens.captionStyle
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            tokens.spaceLg,
            tokens.spaceLg,
            tokens.spaceLg,
            tokens.spaceMd,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: tokens.titleStyle),
              ),
            ],
          ),
        ),
        child,
        SizedBox(height: tokens.spaceXs),
        Divider(color: tokens.divider, height: 1),
      ],
    );
  }
}
