import 'package:flutter/widgets.dart';

// ── Responsive font / icon scaling (context-free) ─────────────────────────

/// Scales layout and font sizes proportionally to the physical screen width.
///
/// Initialization:
/// 1. [bootstrap] seeds it from [PlatformDispatcher] before the first frame.
/// 2. [SilkApp.build] refreshes it via [MediaQuery.sizeOf] so rotation and
///    multi-window scenarios are handled automatically.
///
/// Design reference: **390 dp** (iPhone 14 — the most common design canvas).
/// Scale is clamped to [0.85 – 1.4] so text stays legible on all screens.
abstract final class SilkSizer {
  static const double designWidth = 390;
  static double _ratio = 1;

  /// Returns the effective logical screen width implied by the current ratio.
  static double get screenWidth => designWidth * _ratio;

  /// Set the actual screen width. Clamps and caches the resulting ratio.
  /// Safe to call on every build — cost is one division + clamp.
  static set screenWidth(double value) {
    _ratio = (value / designWidth).clamp(0.85, 1.4);
  }

  /// Scale factor relative to the [designWidth] canvas (0.85 – 1.4).
  static double get ratio => _ratio;

  /// Scale [size] proportionally to the current screen width.
  static double scale(double size) => size * _ratio;
}

/// Context-free responsive scale for all typography values.
///
/// All three extensions delegate to [SilkSizer.scale] so they move in lockstep
/// with the screen width. [SilkSizer.screenWidth] is updated by [SilkApp]
/// before tokens are evaluated, so no [BuildContext] is required here.
///
/// ```dart
/// fontSize:      16.sp           // font size
/// height:         1.5.lh         // line-height multiplier
/// letterSpacing: (-0.5).ls       // letter spacing in logical pixels
/// ```
extension SilkSizeExtension on num {
  /// Responsive font size — scales proportionally to the screen width.
  double get sp => SilkSizer.scale(toDouble());

  /// Identical to [sp] — explicit method form preferred by some teams.
  double fontSize() => SilkSizer.scale(toDouble());

  /// Responsive line-height value for **absolute** line heights expressed in
  /// logical pixels (e.g. a fixed row height, not [TextStyle.height]).
  ///
  /// Do NOT use this for [TextStyle.height] — that property is already a ratio
  /// relative to [fontSize], so scaling it creates a ratio² effect on the
  /// rendered line height. Use a plain [double] literal there instead.
  double get lh => SilkSizer.scale(toDouble());

  /// Responsive letter spacing in logical pixels (TextStyle.letterSpacing).
  /// Letter spacing is an absolute value so it must scale alongside font size.
  double get ls => SilkSizer.scale(toDouble());
}

// ── Fractional screen dimensions (context-aware) ──────────────────────────

/// Fractional screen dimension helpers as extensions on [double].
///
/// Every method takes a [BuildContext] so the value is always derived from
/// the real device dimensions at call time via [MediaQuery.sizeOf].
///
/// ```dart
/// SizedBox(width: 0.5.sw(context))          // 50% of screen width
/// SizedBox(height: 0.3.sh(context))         // 30% of screen height
/// Padding(top: 0.1.safeHeight(context))     // 10% of safe-area height
/// ```
extension DoubleDimension on double {
  /// [this] fraction of the full logical screen width.
  double sw(BuildContext context) =>
      MediaQuery.sizeOf(context).width * this;

  /// [this] fraction of the full logical screen height.
  double sh(BuildContext context) =>
      MediaQuery.sizeOf(context).height * this;

  /// [this] fraction of the screen width minus horizontal safe-area insets.
  double safeWidth(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    return (size.width - padding.left - padding.right) * this;
  }

  /// [this] fraction of the screen height minus status bar and home indicator.
  double safeHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    return (size.height - padding.top - padding.bottom) * this;
  }

  /// [this] fraction of the available height — excludes safe area and the
  /// software keyboard when visible.
  double availableHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return (size.height - padding.top - padding.bottom - keyboard) * this;
  }
}

// ── Screen metadata (context-aware) ───────────────────────────────────────

/// Non-fractional screen and system-UI metrics on [BuildContext].
///
/// Uses the fine-grained [MediaQuery.paddingOf] / [MediaQuery.viewInsetsOf]
/// variants so widgets rebuild only when the specific value changes.
extension DimensionContext on BuildContext {
  /// System safe-area insets (status bar, notch, home indicator).
  EdgeInsets get safeArea => MediaQuery.paddingOf(this);

  /// Height of the status bar / notch area.
  double get statusBarHeight => MediaQuery.paddingOf(this).top;

  /// Height of the home indicator / bottom system navigation bar.
  double get bottomBarHeight => MediaQuery.paddingOf(this).bottom;

  /// Height of the software keyboard when visible; 0 otherwise.
  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  /// Whether the software keyboard is currently on screen.
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;
}
