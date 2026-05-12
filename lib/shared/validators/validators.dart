/// A validator returns `null` when the value is valid, or an error string.
typedef Validator = String? Function(String? value);

/// Composable field validators for use with [SilkTextField] or [Form].
abstract final class Validators {
  // ── Primitives ─────────────────────────────────────────────────────────────

  static Validator required([String message = 'Required']) =>
      (v) => (v == null || v.trim().isEmpty) ? message : null;

  static Validator minLength(int min, [String? message]) =>
      (v) => (v != null && v.length < min)
          ? (message ?? 'Must be at least $min characters')
          : null;

  static Validator maxLength(int max, [String? message]) =>
      (v) => (v != null && v.length > max)
          ? (message ?? 'Must be at most $max characters')
          : null;

  static Validator email([String message = 'Enter a valid email']) {
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return (v) => (v != null && !re.hasMatch(v)) ? message : null;
  }

  static Validator phone([String message = 'Enter a valid phone number']) {
    final re = RegExp(r'^\+?[\d\s\-().]{7,15}$');
    return (v) => (v != null && v.isNotEmpty && !re.hasMatch(v))
        ? message
        : null;
  }

  static Validator pattern(RegExp re, [String message = 'Invalid format']) =>
      (v) => (v != null && v.isNotEmpty && !re.hasMatch(v)) ? message : null;

  static Validator match(
    String? Function() getOther, [
    String message = 'Values do not match',
  ]) =>
      (v) => v != getOther() ? message : null;

  // ── Composition ────────────────────────────────────────────────────────────

  /// Runs [validators] in order and returns the first error found.
  static Validator compose(List<Validator> validators) =>
      (v) => validators.map((fn) => fn(v)).firstWhere(
            (e) => e != null,
            orElse: () => null,
          );
}
