import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/core/theme/theme_mode_provider.dart';
import 'package:silk/features/auth/presentation/providers/session_provider.dart';
import 'package:silk/shared/widgets/silk_alert.dart';
import 'package:silk/shared/widgets/silk_amount_field.dart';
import 'package:silk/shared/widgets/silk_app_bar.dart';
import 'package:silk/shared/widgets/silk_avatar.dart';
import 'package:silk/shared/widgets/silk_badge.dart';
import 'package:silk/shared/widgets/silk_bottom_nav_bar.dart';
import 'package:silk/shared/widgets/silk_bottom_sheet.dart';
import 'package:silk/shared/widgets/silk_button.dart';
import 'package:silk/shared/widgets/silk_calendar.dart';
import 'package:silk/shared/widgets/silk_card.dart';
import 'package:silk/shared/widgets/silk_checkbox.dart';
import 'package:silk/shared/widgets/silk_chip.dart';
import 'package:silk/shared/widgets/silk_context_menu.dart';
import 'package:silk/shared/widgets/silk_date_picker.dart';
import 'package:silk/shared/widgets/silk_date_time_picker.dart';
import 'package:silk/shared/widgets/silk_divider.dart';
import 'package:silk/shared/widgets/silk_dropdown.dart';
import 'package:silk/shared/widgets/silk_empty_state.dart';
import 'package:silk/shared/widgets/silk_expandable.dart';
import 'package:silk/shared/widgets/silk_expandable_text.dart';
import 'package:silk/shared/widgets/silk_icon_button.dart';
import 'package:silk/shared/widgets/silk_list_tile.dart';
import 'package:silk/shared/widgets/silk_loading_overlay.dart';
import 'package:silk/shared/widgets/silk_multi_value_select_input.dart';
import 'package:silk/shared/widgets/silk_otp_field.dart';
import 'package:silk/shared/widgets/silk_phone_input.dart';
import 'package:silk/shared/widgets/silk_progress_bar.dart';
import 'package:silk/shared/widgets/silk_pull_to_refresh.dart';
import 'package:silk/shared/widgets/silk_radio_group.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';
import 'package:silk/shared/widgets/silk_search_bar.dart';
import 'package:silk/shared/widgets/silk_segmented_control.dart';
import 'package:silk/shared/widgets/silk_shimmer.dart';
import 'package:silk/shared/widgets/silk_skeleton.dart';
import 'package:silk/shared/widgets/silk_slider.dart';
import 'package:silk/shared/widgets/silk_stepper.dart';
import 'package:silk/shared/widgets/silk_swipe_action.dart';
import 'package:silk/shared/widgets/silk_switch.dart';
import 'package:silk/shared/widgets/silk_tab_bar.dart';
import 'package:silk/shared/widgets/silk_text_field.dart';
import 'package:silk/shared/widgets/silk_time_picker.dart';
import 'package:silk/shared/widgets/silk_toast.dart';

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
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
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
