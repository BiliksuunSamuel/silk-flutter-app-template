# Silk — Flutter App Template

A production-ready Flutter template. Token-driven design system, physics-based interactions, responsive typography, and all the infrastructure a real app needs wired up from day one.

---

## Quick start

**Requirements:** Flutter 3.35.7 · Dart 3.9.2

```bash
git clone <repo-url> my_app && cd my_app

# 1. Rename the template (package name, bundle ID, display name)
dart run tool/rename.dart \
  --name=my_app \
  --org=com.example \
  --display="My App"

# 2. Install dependencies and regenerate code
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# 3. Run
flutter run --dart-define=BASE_URL=https://your-api.com
```

### What the rename script changes

| Location | What changes |
|---|---|
| All `.dart` files | `package:silk/` → `package:my_app/` |
| `pubspec.yaml` | `name: silk` → `name: my_app` |
| `android/app/build.gradle.kts` | namespace + applicationId |
| `android/.../AndroidManifest.xml` | package attribute |
| `android/.../MainActivity.kt` | package declaration + moved to new directory |
| `ios/Runner.xcodeproj/project.pbxproj` | `PRODUCT_BUNDLE_IDENTIFIER` |
| `ios/Runner/Info.plist` | `CFBundleDisplayName`, `CFBundleName` |
| `lib/app/app.dart` | `MaterialApp` title |
| `lib/l10n/app_en.arb` | `appName` string |

**What the script does NOT change:** `Silk*` widget names and file names — they belong to the design system, not the app. You can rename them later if you want, but it is not required.

Run with environment config:

```bash
flutter run \
  --dart-define=ENV=development \
  --dart-define=BASE_URL=https://your-api.com
```

---

## Non-negotiables

These rules keep the codebase consistent across features and authors:

1. **No raw `Duration(...)` or `Curves.*` in feature code.** Use `MotionTokens`.
2. **No hardcoded colors, spacing, radii, or text styles.** Use `context.tokens`.
3. **No `ElevatedButton`, `TextField`, `ListTile`, etc. in features.** Use `Silk*` widgets.
4. **No `FutureBuilder` or `setState` for async UI.** Use Riverpod `AsyncValue`.
5. **No `if (isDark) ... else ...` branches.** Dark mode is a second token set — same widget tree.
6. **No `print()`.** Use `AppLogger`.
7. **No literal font sizes, line heights, or letter spacing.** Use `.sp`, `.ls` and the token type styles.

---

## Project structure

```
lib/
├── main.dart
├── app/                    # Wire-up only — no logic
│   ├── app.dart            # MaterialApp.router, theme, l10n, SilkSizer refresh
│   ├── bootstrap.dart      # Error handlers, crash reporter, SilkSizer seed
│   └── scroll_behavior.dart
│
├── core/                   # App-wide infrastructure — no feature logic
│   ├── analytics/          # AnalyticsService interface + stub
│   ├── config/             # AppConfig (--dart-define env/flavors)
│   ├── connectivity/       # Reactive network status + SilkOfflineBanner
│   ├── crash/              # CrashReporter interface + stub
│   ├── error/              # AppFailure + FailureMapper
│   ├── extensions/         # SilkSizer, .sp / .ls / .lh / .sw / .sh
│   ├── logging/            # AppLogger
│   ├── media/              # MediaService (image + file picking)
│   ├── motion/             # MotionTokens, Haptics, scroll physics
│   ├── network/            # HttpClient, ApiException, Dio, interceptors
│   ├── notifications/      # PushNotificationService interface + stub
│   ├── permissions/        # PermissionService
│   ├── router/             # go_router config, route paths, page transitions
│   ├── storage/            # KeyValueStore → PrefsStore / SecureStore
│   └── theme/              # AppTokens, AppTypography, light/dark tokens,
│                           # ThemeBuilder, SilkIconSize, SilkFontSize
│
├── features/               # One folder per product feature
│   └── <feature>/
│       ├── data/           # API client, repository, models
│       ├── domain/         # Pure models — no Flutter, no Dio
│       └── presentation/
│           ├── providers/  # Riverpod notifiers
│           ├── screens/
│           └── widgets/    # Feature-scoped widgets
│
├── shared/                 # Cross-feature, reusable
│   ├── extensions/         # BuildContext + AsyncValue helpers
│   ├── pagination/         # PaginatedState<T> + PaginatedNotifierMixin<T>
│   ├── validators/         # Composable form validators
│   └── widgets/            # All Silk components
│
└── l10n/                   # Generated ARB localizations
```

**Dependency rules**

- `features/` → `core/` and `shared/`, never another feature
- `shared/` → `core/`, never `features/`
- `core/` → nothing in `lib/` except other `core/` modules
- Within a feature: `domain/` has no Flutter deps; `data/` depends on `domain/`; `presentation/` depends on both

---

## Design system

### Tokens — Solid UI

The template follows the **Solid UI** system: calm flat surfaces, hairlines instead of borders-and-shadows everywhere, one scarce accent, and shadows only on things that genuinely float.

Every visual value lives in `AppTokens`, a `ThemeExtension`. Access it via `context.tokens`.

```dart
Container(color: context.tokens.surface)
SizedBox(height: context.tokens.spaceMd)      // 16
Text('Title', style: context.tokens.titleStyle)
```

| Slot | Use |
|---|---|
| `canvas` / `surface` / `surfaceMuted` | Scaffold bg / cards, sheets, inputs / sunken fills (segment track, skeletons) |
| `onSurface` / `body` / `onSurfaceMuted` / `subtle` | Ink / body text / secondary text / timestamps (never actionable) |
| `hairline` / `hairlineSoft` / `hairlineStrong` | Dividers / card borders / input & secondary-button borders |
| `accent` / `onAccent` / `accentInk` / `accentTint` | Brand fill / text on accent / accent text on surface / selected highlight |
| `success` `warning` `danger` (+ `…Tint`) | Status pills and text |

**The accent is one swappable slot.** Change `kLightAccent` / `kDarkAccent` in `light_tokens.dart` / `dark_tokens.dart`; `onAccent` (white or black, ≥ 4.5:1) and `accentInk` (≥ 4.5:1 as text) are derived by `ColorContrast`, so any brand colour stays accessible. Always use `tokens.onAccent`, never `Colors.white`, for content on the accent.

**Elevation is earned.** Rows, cards, bubbles and inputs never get a shadow. Only floating surfaces do: `shadowSegment` (active segment), `shadowFloating` (sheets, dialogs, menus, toasts, FAB) and `shadowPrimaryButton`.

**Radii:** `radiusMd` 12 controls · `radiusLg` 20 cards · `radiusMedia` 16 · `radiusSegment` 9 · `radiusSheet` 28 · `radiusPill`. **Spacing:** 4 · 8 · 16 · 24 · 32 · 56.

Material 3 is configured to match (`theme_builder.dart`): no surface tint, no ink ripples (use `PressableScale`), 0.5px hairline dividers, Cupertino page transitions, frosted bars via `FrostedBar`.

Light and dark values are defined in `light_tokens.dart` / `dark_tokens.dart`. To add a token: update `AppTokens` in `tokens.dart`, then update both token files.

### Typography

Solid type scale on Inter. All sizes responsive via `SilkSizer`. Wrap a style in `AppTypography.tabular(...)` for money, times and counts.

| Token | Size / line | Weight | Use |
|---|---|---|---|
| `displayStyle` | 34 / 40 | 700 | Large screen titles |
| `headlineStyle` | 28 / 34 | 700 | Sheet titles, empty states |
| `titleStyle` | 22 / 28 | 700 | Section titles |
| `title3Style` | 20 / 25 | 600 | Card titles, amounts |
| `titleSmStyle` | 17 / 22 | 600 | Row titles, buttons, nav titles |
| `bodyStyle` | 17 / 24 | 400 | Messages, paragraphs |
| `calloutStyle` | 16 / 21 | 400 | Secondary paragraphs |
| `bodySmStyle` | 15 / 20 | 400 | Row subtitles, dense body |
| `labelStyle` | 13 / 18 | 500 | Metadata, helper text, chips |
| `captionStyle` | 12 / 16 | 500 | Timestamps, pill labels |
| `overlineStyle` | 11 / 13 | 600 | Rare: grouped-list section headers |
| `monoStyle` | 14 | 400 mono | Code, OTP, numeric fields |

To change the font, update the `GoogleFonts.*` call in `app_typography.dart`.

### Responsive sizing

`SilkSizer` scales values against a 390 dp design canvas (iPhone 14). It is seeded before the first frame in `bootstrap.dart` and refreshed on every `SilkApp` rebuild to handle rotation automatically.

```dart
// Typography (context-free — SilkSizer holds the current screen width)
fontSize:      16.sp
letterSpacing: (-0.3).ls     // letter spacing in logical pixels, scales with screen

// Note: TextStyle.height is a ratio relative to fontSize — do NOT use .lh there,
// it would create a ratio² effect. Use plain doubles: height: 1.5

// Fractional layout (needs context for live MediaQuery values)
0.5.sw(context)              // 50 % of screen width
0.3.sh(context)              // 30 % of screen height
0.8.safeHeight(context)      // 80 % minus status bar + home indicator
0.6.availableHeight(context) // 80 % minus safe area and keyboard

// System UI metadata
context.statusBarHeight
context.bottomBarHeight
context.keyboardHeight
context.isKeyboardVisible

// Size constants
Icon(Icons.star, size: SilkIconSize.md)   // 24 — xs 14 / sm 18 / md 24 / lg 32 / xl 48
```

---

## Environments / flavors

Configuration is injected at compile time via `--dart-define`. No `.env` files, no multiple entry points.

```bash
# Local (defaults: ENV=development, BASE_URL=https://httpbin.org)
flutter run

# Staging
flutter run \
  --dart-define=ENV=staging \
  --dart-define=BASE_URL=https://staging-api.example.com

# Production build
flutter build apk \
  --dart-define=ENV=production \
  --dart-define=BASE_URL=https://api.example.com
```

Read values anywhere:

```dart
AppConfig.baseUrl         // String
AppConfig.isDevelopment   // bool
AppConfig.isProduction    // bool
```

**VS Code** — `.vscode/launch.json`:

```json
{
  "configurations": [
    {
      "name": "Silk – dev",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=ENV=development",
        "--dart-define=BASE_URL=https://dev-api.example.com"
      ]
    }
  ]
}
```

---

## Networking

All HTTP calls go through `HttpClient`, which wraps Dio and maps `DioException → ApiException` at the boundary. Repositories catch `ApiException` and convert it to `AppFailure` via `FailureMapper`.

```
HttpClient → ApiException → FailureMapper → AppFailure
```

```dart
// In an API class
final res = await _client.post<Map<String, dynamic>>(
  HttpRequestDto(url: '/auth/login', data: body),
);

// In a repository
try {
  final res = await _api.login(request);
  return Result.success(res);
} on ApiException catch (e) {
  return Result.failure(FailureMapper.map(e));
}
```

`AuthInterceptor` attaches the session token automatically and handles `401 → silent refresh → retry`. A separate `_refreshDio` instance is used for the refresh call to avoid circular interception.

---

## Swapping stub services

Four services ship as no-op stubs and are designed to be replaced. Override the provider in `ProviderScope` at startup.

### Analytics

Implement `AnalyticsService` and override `analyticsServiceProvider`:

```dart
// lib/main.dart
await bootstrap(
  () => ProviderScope(
    overrides: [
      analyticsServiceProvider.overrideWithValue(FirebaseAnalyticsService()),
    ],
    child: const SilkApp(),
  ),
);
```

### Crash reporting

Implement `CrashReporter` and override `crashReporterProvider`. The error handlers in `bootstrap.dart` (`FlutterError.onError`, `PlatformDispatcher.instance.onError`) automatically call through to it — no changes needed there.

### Push notifications

Implement `PushNotificationService` and override `pushNotificationServiceProvider`. The interface covers `requestPermission()`, `getToken()`, `onMessage` stream, and `onNotificationTap` stream.

### Connectivity

No stub — `connectivityStreamProvider` is a live `Stream<bool>` via `connectivity_plus`. Drop `SilkOfflineBanner` above your scaffold body:

```dart
body: Column(
  children: [
    const SilkOfflineBanner(),
    Expanded(child: yourContent),
  ],
)
```

---

## Adding a feature

1. Create `lib/features/<name>/` with `data/`, `domain/`, `presentation/`
2. Define your domain model in `domain/` — plain Dart, no imports outside `dart:core`
3. Add an API class in `data/` using `HttpClient`
4. Add a repository in `data/` returning `Result<T, AppFailure>`
5. Add a Riverpod notifier in `presentation/providers/`
6. Build screens in `presentation/screens/`
7. Register routes in `core/router/app_router.dart` and `route_paths.dart`

---

## Pagination

Mix `PaginatedNotifierMixin<T>` into any Riverpod `Notifier` to get first-page loading, load-more, and refresh:

```dart
@riverpod
class PostsNotifier extends _$PostsNotifier
    with PaginatedNotifierMixin<Post> {
  @override
  PaginatedState<Post> build() => loadFirstPage();

  @override
  Future<(List<Post>, bool)> fetchPage(int page) async {
    final posts = await ref.read(postRepoProvider).getPosts(page: page);
    return (posts, posts.length == 20);
  }
}
```

---

## Form validation

Validators are composable functions of type `String? Function(String? value)`:

```dart
SilkTextField(
  hint: 'Email',
  validator: Validators.compose([
    Validators.required(),
    Validators.email(),
  ]),
)
```

Built-in validators: `required`, `email`, `phone`, `minLength`, `maxLength`, `pattern`, `match`, `compose`.

---

## Localization

Strings live in `lib/l10n/app_en.arb`. After editing:

```bash
flutter gen-l10n
```

```dart
Text(AppLocalizations.of(context).signIn)
```

To add a language, create `lib/l10n/app_<locale>.arb` and list the locale in `l10n.yaml`.

---

## Codegen

Any change to a `@riverpod` provider or `@freezed` class needs regeneration:

```bash
dart run build_runner build --delete-conflicting-outputs

# Or in watch mode during active development
dart run build_runner watch --delete-conflicting-outputs
```

---

## Tech stack

| Concern | Package |
|---|---|
| State | `flutter_riverpod` + `riverpod_generator` |
| Navigation | `go_router` |
| HTTP | `dio` + `HttpClient` wrapper |
| Serialization | `freezed` + `json_serializable` |
| Storage | `shared_preferences` + `flutter_secure_storage` |
| Typography | `google_fonts` (Inter + JetBrains Mono) |
| Animation | `flutter_animate` + `animations` |
| Images | `cached_network_image` + `flutter_svg` |
| Connectivity | `connectivity_plus` |
| Permissions | `permission_handler` |
| Media | `image_picker` + `file_picker` |
| Localization | `flutter_localizations` + `intl` |
| Linting | `very_good_analysis` |
| Codegen | `build_runner` |

---

## Components

| Widget | Description |
|---|---|
| `SilkButton` | Primary / secondary / ghost / danger variants |
| `SilkIconButton` | Icon button with reaction burst |
| `SilkSvgButton` | SVG icon button |
| `SilkTextField` | Animated border, inline validator, prefix/suffix |
| `SilkSearchBar` | Compact, slim search input |
| `SilkAppBar` | Token-styled app bar |
| `SilkBackButton` | Themed back button |
| `SilkBottomNavBar` | Nav bar with particle burst on tap |
| `SilkBottomSheet` | Modal bottom sheet |
| `SilkListTile` | Token-styled list tile |
| `SilkAvatar` | Cached image avatar with initials fallback |
| `SilkBadge` | Notification / count badge |
| `SilkChip` | Selectable / deletable chip |
| `SilkSwitch` | Spring-animated toggle with thumb stretch |
| `SilkCheckbox` | Animated checkbox with reaction burst |
| `SilkRadioGroup` | Radio group with reaction burst on dot |
| `SilkSegmentedControl` | Generic segmented control |
| `SilkDropdown` | Dropdown selector |
| `SilkMultiValueSelectInput` | Multi-value select |
| `SilkContextMenu` | Long-press context menu with squish animation |
| `SilkProgressBar` | Animated fill bar — accent / success / danger |
| `SilkDivider` | Plain or labeled divider |
| `SilkEmptyState` | Icon + title + body + optional CTA |
| `SilkToast` | Transient notification with spring entry |
| `SilkShimmer` | Shimmer loading effect |
| `SilkSkeleton` | Skeleton screens — `listItem`, `card`, `text` |
| `SilkCalendar` | Calendar |
| `SilkDatePicker` | Date picker |
| `SilkTimePicker` | Time picker |
| `SilkDateTimePicker` | Combined date + time picker |
| `SilkPullToRefresh` | Pull-to-refresh wrapper |
| `SilkGestureBack` | Swipe-back gesture handler |
| `SilkReactionBurst` | Particle burst — wrapper and imperative `trigger()` |
