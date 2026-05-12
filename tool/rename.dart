// Script file — print statements are intentional, single-quote rule doesn't
// apply to strings that embed JSON double quotes.
// ignore_for_file: avoid_print, prefer_single_quotes

/// Renames the Silk template for a new project.
///
/// Usage:
/// ```shell
/// dart run tool/rename.dart --name=package --org=com.example --display="My App"
/// ```
///
/// Example:
/// ```shell
/// dart run tool/rename.dart --name=my_app --org=com.acme --display="My App"
/// ```
///
/// What changes:
///   - Dart package name in pubspec.yaml and all import paths
///   - Android namespace, applicationId, source directory, MainActivity package
///   - iOS PRODUCT_BUNDLE_IDENTIFIER (project.pbxproj)
///   - iOS CFBundleDisplayName and CFBundleName (Info.plist)
///   - App title in lib/app/app.dart
///   - App name in lib/l10n/app_en.arb
///
/// What does NOT change:
///   - Silk* widget class names (they belong to the design system, not the app)
///   - AppTokens, AppTypography, MotionTokens and other core type names
library;

import 'dart:io';

// ── Current template values ────────────────────────────────────────────────

const _currentPackage = 'silk';
const _currentBundleId = 'co.silk.app.silk';
const _currentBundleIdTests = 'co.silk.app.silk.RunnerTests';
const _currentDisplayName = 'Silk';
const _currentBundleName = 'silk'; // CFBundleName (lowercase)
const _currentAndroidDir = 'co/silk/app/silk';

// ──────────────────────────────────────────────────────────────────────────

void main(List<String> args) {
  final params = _parseArgs(args);
  final name = params['name']!;
  final org = params['org']!;
  final display = params['display'] ?? _toDisplayName(name);

  _validate(name: name, org: org);

  final bundleId = '$org.$name';
  final bundleIdTests = '$org.$name.RunnerTests';
  final androidDir = '${org.replaceAll('.', '/')}/$name';

  print('\nSilk → $display');
  print('  package  : $name');
  print('  bundle   : $bundleId');
  print('  display  : $display\n');

  final root = _projectRoot();

  // ── 1. Dart files (lib/, test/, widgetbook/) ──────────────────────────────
  _replaceInDir(
    root,
    extensions: {'.dart'},
    from: "package:$_currentPackage/",
    to: "package:$name/",
    label: 'Dart imports',
  );

  // ── 2. pubspec.yaml ────────────────────────────────────────────────────────
  _replaceInFile(
    path: '$root/pubspec.yaml',
    from: 'name: $_currentPackage',
    to: 'name: $name',
    label: 'pubspec.yaml',
  );

  // ── 3. Android — build.gradle.kts ─────────────────────────────────────────
  final gradlePath = '$root/android/app/build.gradle.kts';
  _replaceInFile(
    path: gradlePath,
    from: 'namespace = "$_currentBundleId"',
    to: 'namespace = "$bundleId"',
    label: 'Android namespace',
  );
  _replaceInFile(
    path: gradlePath,
    from: 'applicationId = "$_currentBundleId"',
    to: 'applicationId = "$bundleId"',
    label: 'Android applicationId',
  );

  // ── 4. Android — AndroidManifest files ────────────────────────────────────
  final mainManifest = '$root/android/app/src/main/AndroidManifest.xml';
  _replaceInFile(
    path: mainManifest,
    from: 'android:label="$_currentBundleName"',
    to: 'android:label="$display"',
    label: 'Android app label',
  );
  for (final variant in ['main', 'debug', 'profile']) {
    _replaceInFile(
      path: '$root/android/app/src/$variant/AndroidManifest.xml',
      from: 'package="$_currentBundleId"',
      to: 'package="$bundleId"',
      label: 'AndroidManifest ($variant)',
      required: variant == 'main',
    );
  }

  // ── 5. Android — MainActivity.kt ──────────────────────────────────────────
  final oldKtPath = '$root/android/app/src/main/kotlin/$_currentAndroidDir/MainActivity.kt';
  final newKtDir  = '$root/android/app/src/main/kotlin/$androidDir';
  final newKtPath = '$newKtDir/MainActivity.kt';

  final ktFile = File(oldKtPath);
  if (ktFile.existsSync()) {
    Directory(newKtDir).createSync(recursive: true);
    final updated = ktFile
        .readAsStringSync()
        .replaceAll('package $_currentBundleId', 'package $bundleId');
    File(newKtPath).writeAsStringSync(updated);

    // Remove old directory tree if the path changed.
    if (oldKtPath != newKtPath) {
      _deleteEmptyAncestors(
        File(oldKtPath).parent,
        stopAt: Directory('$root/android/app/src/main/kotlin'),
      );
    }
    print('✓ MainActivity.kt  ($bundleId)');
  } else {
    print('⚠ MainActivity.kt not found at expected path — skipping');
  }

  // ── 6. iOS — project.pbxproj ──────────────────────────────────────────────
  _replaceInFile(
    path: '$root/ios/Runner.xcodeproj/project.pbxproj',
    from: 'PRODUCT_BUNDLE_IDENTIFIER = $_currentBundleId;',
    to: 'PRODUCT_BUNDLE_IDENTIFIER = $bundleId;',
    label: 'iOS bundle identifier (Runner)',
    replaceAll: true,
  );
  _replaceInFile(
    path: '$root/ios/Runner.xcodeproj/project.pbxproj',
    from: 'PRODUCT_BUNDLE_IDENTIFIER = $_currentBundleIdTests;',
    to: 'PRODUCT_BUNDLE_IDENTIFIER = $bundleIdTests;',
    label: 'iOS bundle identifier (RunnerTests)',
    replaceAll: true,
    required: false,
  );

  // ── 7. iOS — Info.plist ───────────────────────────────────────────────────
  _replaceInFile(
    path: '$root/ios/Runner/Info.plist',
    from: '<string>$_currentDisplayName</string>\n\t<key>CFBundleExecutable</key>',
    to: '<string>$display</string>\n\t<key>CFBundleExecutable</key>',
    label: 'iOS CFBundleDisplayName',
  );
  _replaceInFile(
    path: '$root/ios/Runner/Info.plist',
    from: '<key>CFBundleName</key>\n\t<string>$_currentBundleName</string>',
    to: '<key>CFBundleName</key>\n\t<string>$name</string>',
    label: 'iOS CFBundleName',
  );

  // ── 8. lib/app/app.dart — MaterialApp title ───────────────────────────────
  _replaceInFile(
    path: '$root/lib/app/app.dart',
    from: "title: '$_currentDisplayName'",
    to: "title: '$display'",
    label: 'MaterialApp title',
  );

  // ── 9. l10n — app_en.arb ──────────────────────────────────────────────────
  _replaceInFile(
    path: '$root/lib/l10n/app_en.arb',
    from: '"appName": "$_currentDisplayName"',
    to: '"appName": "$display"',
    label: 'l10n appName',
    required: false,
  );

  print('\nDone. Run the following to finish:\n');
  print('  dart run build_runner build --delete-conflicting-outputs');
  print('  flutter gen-l10n\n');
}

// ── Helpers ────────────────────────────────────────────────────────────────

void _replaceInDir(
  String root, {
  required Set<String> extensions,
  required String from,
  required String to,
  required String label,
}) {
  var count = 0;
  final dir = Directory(root);
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!extensions.any((e) => entity.path.endsWith(e))) continue;

    final content = entity.readAsStringSync();
    if (!content.contains(from)) continue;
    entity.writeAsStringSync(content.replaceAll(from, to));
    count++;
  }
  print('✓ $label  ($count file${count == 1 ? '' : 's'})');
}

void _replaceInFile({
  required String path,
  required String from,
  required String to,
  required String label,
  bool replaceAll = false,
  bool required = true,
}) {
  final file = File(path);
  if (!file.existsSync()) {
    if (required) print('⚠ $label — file not found: $path');
    return;
  }
  final content = file.readAsStringSync();
  if (!content.contains(from)) {
    if (required) print('⚠ $label — pattern not found in $path');
    return;
  }
  final updated = replaceAll
      ? content.replaceAll(from, to)
      : content.replaceFirst(from, to);
  file.writeAsStringSync(updated);
  print('✓ $label');
}

void _deleteEmptyAncestors(Directory dir, {required Directory stopAt}) {
  if (dir.path == stopAt.path) return;
  try {
    if (dir.existsSync() && dir.listSync().isEmpty) {
      dir.deleteSync();
      _deleteEmptyAncestors(dir.parent, stopAt: stopAt);
    }
  } on Exception {
    // Non-critical — ignore if deletion fails.
  }
}

String _projectRoot() {
  // Script lives in tool/rename.dart; project root is one level up.
  final script = Platform.script.toFilePath();
  return File(script).parent.parent.path;
}

String _toDisplayName(String packageName) =>
    packageName
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');

Map<String, String> _parseArgs(List<String> args) {
  final params = <String, String>{};
  for (final arg in args) {
    if (!arg.startsWith('--')) _die('Unknown argument: $arg');
    final eq = arg.indexOf('=');
    if (eq == -1) _die('Expected --key=value, got: $arg');
    final key = arg.substring(2, eq);
    final value = arg.substring(eq + 1).replaceAll('"', '').replaceAll("'", '');
    params[key] = value;
  }
  if (!params.containsKey('name')) _die('--name is required');
  if (!params.containsKey('org'))  _die('--org is required');
  return params;
}

void _validate({required String name, required String org}) {
  final nameRe = RegExp(r'^[a-z][a-z0-9_]*$');
  if (!nameRe.hasMatch(name)) {
    _die('--name must be lowercase snake_case (e.g. my_app). Got: $name');
  }
  final orgRe = RegExp(r'^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$');
  if (!orgRe.hasMatch(org)) {
    _die('--org must be a reverse domain (e.g. com.acme). Got: $org');
  }
}

Never _die(String message) {
  print('\nError: $message\n');
  print('Usage: dart run tool/rename.dart --name=<package> --org=<org> [--display="Display Name"]\n');
  exit(1);
}
