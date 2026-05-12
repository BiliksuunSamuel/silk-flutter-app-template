# Flutter App Template — Telegram-Grade Smoothness

## Context

You are scaffolding a production-ready Flutter app template. The single
defining quality goal is **UI smoothness and motion fidelity comparable to
Telegram**: no jank, no blocking loaders, consistent motion language, gestures
that feel native on both platforms, and transitions that read as intentional
rather than generic.

This is a **template**, not a one-off app. Future features will be added on top
of it. Every architectural decision should reduce the number of choices a
feature author has to make. If a question like "what duration should this
animation use?" or "what color should this button be?" can be answered in
feature code, the template has failed.

Read the **Non-Negotiables** before writing any code. Refer back to them often.

---

## Non-Negotiables

These are enforced rules. Do not violate them, even in example code.

1. **No literal `Duration(...)` or `Curves.*` in feature code.** All motion
   values come from `MotionTokens`. Add new tokens if needed; never inline.
2. **No hardcoded colors, spacings, radii, or text styles in feature code.**
   All design values come from `context.tokens` (a `ThemeExtension`).
3. **No direct use of Material widgets like `ElevatedButton`, `TextField`,
   `BottomSheet`, `ListTile` in features.** Features use the `Silk*` layer in
   `lib/shared/widgets/`. The Silk layer wraps Material.
4. **No raw `FutureBuilder` or `Future + setState` for async UI.** All async
   state flows through Riverpod's `AsyncValue`.
5. **No `if (isDark) ... else ...` branches.** Dark mode is a second token set
   passed to the theme. Widgets read the same `context.tokens` in either mode.
6. **No `print()` calls.** Use `AppLogger`.
7. **No `MaterialApp.router` without the custom `ScrollBehavior`** that
   applies the tuned scroll physics app-wide.
8. **Every `Silk*` widget has a demo screen** in the widgetbook so the template
   can be inspected visually.

---

## Tech Stack

| Concern         | Package                                                  | Notes                                              |
| --------------- | -------------------------------------------------------- | -------------------------------------------------- |
| State           | `flutter_riverpod` + `riverpod_annotation` + generator   | Codegen-first; no manual Provider declarations     |
| Navigation      | `go_router`                                              | Custom `PageRouteBuilder` per route family         |
| HTTP            | `dio` + `retrofit`                                       | Typed clients; interceptor chain                   |
| Serialization   | `freezed` + `json_serializable`                          | Sealed types, immutable models, `copyWith`         |
| Local storage   | `flutter_secure_storage` + `shared_preferences`          | Secrets vs prefs, abstracted behind `KeyValueStore`|
| Animation       | `flutter_animate` + `animations`                         | Declarative chains + screen-level transitions      |
| Media           | `cached_network_image`                                   | Memory + disk cache configured up front            |
| Haptics         | `flutter/services` (`HapticFeedback`)                    | Wrapped in `Haptics` helper                        |
| Logging         | `logger`                                                 | Wrapped in `AppLogger`                             |
| Lints           | `very_good_analysis`                                     | Strict; warnings treated as errors                 |
| Widget catalog  | `widgetbook` + `widgetbook_annotation`                   | Auto-generated catalog of every `Silk*` widget      |

Use the latest stable versions at the time of scaffolding. Pin them in
`pubspec.yaml`.

---

## Project Structure

```
lib/
  main.dart                          # Bootstrap: ProviderScope + runApp
  app/
    app.dart                         # Root MaterialApp.router widget
    bootstrap.dart                   # Async init: storage, logger, dio, errors
    scroll_behavior.dart             # Custom ScrollBehavior with tuned physics
  core/
    theme/
      tokens.dart                    # AppTokens ThemeExtension (color, space, radii, type)
      light_tokens.dart              # Light-mode token instance
      dark_tokens.dart               # Dark-mode token instance
      theme_builder.dart             # ThemeData factory from tokens
      context_tokens_extension.dart  # context.tokens getter
    motion/
      motion_tokens.dart             # Durations, curves, spring descriptions
      page_transitions.dart          # SharedAxis, Modal, Fade, ContainerTransform
      scroll_physics.dart            # SilkScrollPhysics extending BouncingScrollPhysics
      haptics.dart                   # Haptics.light/medium/selection helpers
    network/
      dio_provider.dart              # Riverpod-provided configured Dio
      interceptors/
        auth_interceptor.dart        # Inject + refresh
        retry_interceptor.dart       # Exponential backoff, 3x, only on 5xx/network
        logging_interceptor.dart     # Dev only
      result.dart                    # sealed Result<T, E>
      api_exception.dart             # ApiException hierarchy (network/auth/server/unknown)
      api_exception_mapper.dart      # DioException → ApiException
    router/
      app_router.dart                # GoRouter with redirect for auth
      route_paths.dart               # Constants
      transitions/
        modal_page.dart              # CustomTransitionPage variants per family
        shared_axis_page.dart
        fade_page.dart
    storage/
      key_value_store.dart           # Interface
      secure_store.dart              # flutter_secure_storage impl
      prefs_store.dart               # shared_preferences impl
    logging/
      app_logger.dart                # Wraps `logger`; tags by feature
    error/
      app_failure.dart               # User-facing failure sealed type
      failure_mapper.dart            # ApiException → AppFailure
  shared/
    widgets/
      silk_button.dart                # Primary, secondary, ghost, destructive
      silk_text_field.dart            # Focus animation, error state
      silk_list_tile.dart             # Pressed-state scale + opacity
      silk_bottom_sheet.dart          # Drag handle, snap points, blurred backdrop
      silk_context_menu.dart          # Long-press → scale-in with backdrop blur
      silk_avatar.dart                # Fallback initials, cached image
      silk_badge.dart
      silk_shimmer.dart               # Skeleton loader matching token radii
      silk_back_button.dart           # Platform-correct (iOS chevron / Android arrow)
      silk_app_bar.dart               # Hero-friendly title, optional blur background
      silk_pull_to_refresh.dart       # Custom indicator
      silk_gesture_back.dart          # iOS-style edge swipe back, works on Android
    extensions/
      build_context_extensions.dart  # context.tokens, context.go, context.push, context.haptics
      async_value_extensions.dart    # .whenSmooth (no hard loading flash)
    physics/
      silk_scroll_physics.dart        # Re-export; physics implementation lives in core/motion
  features/
    auth/                            # Example feature — auth flow
      data/
        auth_api.dart                # Retrofit client
        auth_repository.dart
        models/
          auth_response.dart         # freezed
          login_request.dart         # freezed
      domain/
        session.dart                 # freezed
      presentation/
        providers/
          auth_controller.dart       # Riverpod AsyncNotifier
          session_provider.dart
        screens/
          login_screen.dart
          otp_screen.dart
        widgets/
          otp_input.dart             # Composed from Silk widgets
test/
  unit/
  widget/
  golden/                            # Golden tests for every Silk* widget, light + dark
widgetbook/
  main.dart                          # Widgetbook entry — separate run target
  use_cases/
    silk_button_use_cases.dart
    silk_text_field_use_cases.dart
    ...                              # One file per Silk widget
```

---

## Motion Tokens — Define These Concretely

In `lib/core/motion/motion_tokens.dart`, declare:

```dart
abstract final class MotionTokens {
  // Durations
  static const Duration micro     = Duration(milliseconds: 100);  // press feedback
  static const Duration fast      = Duration(milliseconds: 180);  // simple fades
  static const Duration standard  = Duration(milliseconds: 240);  // most transitions
  static const Duration emphasized= Duration(milliseconds: 320);  // sheets, modals
  static const Duration slow      = Duration(milliseconds: 480);  // hero, container transform

  // Curves — pick from Material 3 emphasized set, plus a custom one
  static const Curve standardCurve     = Curves.easeOutCubic;
  static const Curve emphasizedDecel   = Cubic(0.05, 0.7, 0.1, 1.0);
  static const Curve emphasizedAccel   = Cubic(0.3, 0.0, 0.8, 0.15);
  static const Curve sharp             = Cubic(0.4, 0.0, 0.6, 1.0);

  // Spring for sheets/FAB (use SpringDescription with SpringSimulation)
  static const SpringDescription bouncy =
      SpringDescription(mass: 1, stiffness: 420, damping: 28);
  static const SpringDescription gentle =
      SpringDescription(mass: 1, stiffness: 280, damping: 24);
}
```

Tune values after the first pass by running the example feature on a real
device and comparing side-by-side with Telegram.

---

## Theme Tokens — `AppTokens` ThemeExtension

`AppTokens` carries: colors (semantic, not raw — `accent`, `surface`,
`surfaceMuted`, `onSurface`, `onSurfaceMuted`, `divider`, `danger`, `success`),
spacing (xs/sm/md/lg/xl/xxl as doubles), radii (sm/md/lg/pill), typography
(display/title/body/caption/mono as `TextStyle`), elevation tokens (shadows
defined per-token, not via `Material elevation:`).

Provide `context.tokens` via an extension on `BuildContext` that calls
`Theme.of(context).extension<AppTokens>()!`.

Light and dark token instances live in separate files. The theme builder takes
an `AppTokens` and returns a fully wired `ThemeData` (so `Theme.of(context)`
still works for any Material widget the Silk layer wraps).

---

## HTTP Layer — Result Type and Exception Hierarchy

`Result<T, E>` is a `freezed` sealed type with `success(T value)` and
`failure(E error)`. Repositories return `Result<T, AppFailure>`; controllers
collapse to `AsyncValue` for UI.

`ApiException` hierarchy: `NetworkException`, `UnauthorizedException`,
`ForbiddenException`, `NotFoundException`, `ServerException`,
`UnknownApiException`. Mapped from `DioException` by a single mapper function.

Interceptor order: logging (dev) → auth → retry. Auth interceptor handles 401
by triggering refresh; on refresh failure, emits a signal the auth controller
listens to and forces logout.

Retry: exponential backoff (300ms, 600ms, 1200ms), max 3 attempts, only on
network errors and 5xx. Never retry POSTs unless the endpoint is explicitly
marked idempotent via a request `extra` flag.

---

## Smoothness Specifics

These are where most templates feel generic. Get them right.

1. **Custom scroll physics applied app-wide.** Extend `BouncingScrollPhysics`
   with a slightly higher fling decel ratio so iOS-style overscroll feels
   intentional on both platforms. Apply via `ScrollBehavior` on
   `MaterialApp.router`.
2. **iOS-style edge swipe back on Android.** Wrap the router shell in
   `SilkGestureBack`. It listens for horizontal drags starting within ~20px of
   the leading edge and pops the route with a translation animation matching
   the push transition in reverse.
3. **Press states.** Every interactive Silk widget has a press animation:
   scale to 0.96 + opacity to 0.8 over `MotionTokens.micro` with
   `MotionTokens.sharp`. No ripples on iOS-feel surfaces (sheet items,
   list tiles); ripples allowed on raised buttons only if visually justified.
4. **AsyncValue without hard loading flashes.** Add an `AsyncValue` extension
   `.whenSmooth` that, on rebuild, keeps showing previous data with a subtle
   shimmer overlay rather than flashing a spinner. Spinners are reserved for
   first-load only.
5. **Image loading.** `cached_network_image` with a fade duration of
   `MotionTokens.fast` and a placeholder built from `SilkShimmer` matching the
   container's radius.
6. **Keyboard animation.** Use `MediaQuery.viewInsets` with implicit animation
   wrappers so screens slide content above the keyboard with the platform's
   actual keyboard curve (not Flutter's default).
7. **Haptics.** `Haptics.selection()` on tab switches and list scroll edges;
   `Haptics.light()` on primary button presses; `Haptics.medium()` on
   destructive confirmations. Wired into Silk widgets, not feature code.
8. **Hero choreography.** Default `transitionOnUserGestures: true` on all
   `Hero` widgets so swipe-back during a hero transition reverses cleanly.

---

## Routing — Transitions per Family

Define four `CustomTransitionPage` variants:

- **Push (default):** shared-axis horizontal, `MotionTokens.standard`,
  `emphasizedDecel`.
- **Modal:** slide up from bottom + dim backdrop, `MotionTokens.emphasized`,
  `emphasizedDecel` in / `emphasizedAccel` out.
- **Replace:** fade-through (out fades, in fades), `MotionTokens.fast`.
- **Container transform:** for list-item → detail using the `animations`
  package's `OpenContainer`, `MotionTokens.slow`.

Each route in `app_router.dart` chooses its family explicitly. Document the
choice in a one-line comment above each route.

---

## Phased Execution Plan

Execute these phases in order. Each phase must satisfy its acceptance criteria
before moving on. Run `flutter analyze` after every phase; it must pass with
zero issues.

### Phase 1 — Bootstrap
- `flutter create` with org and project name (ask the user, default
  `co.silk.app` and `silk`).
- Configure `analysis_options.yaml` with `very_good_analysis`.
- Set up `build.yaml` for codegen.
- Add `main.dart` with `ProviderScope` and `bootstrap()` calling.
- Add `bootstrap.dart` stub.
- **Acceptance:** `flutter run` shows a blank scaffolded screen, analyze
  clean.

### Phase 2 — Theme Tokens
- Implement `AppTokens` `ThemeExtension`, light + dark instances, theme
  builder, `context.tokens` extension.
- Pick a neutral but distinctive base palette (not Material defaults). A
  desaturated indigo accent on near-black dark / off-white light reads well
  and won't feel generic.
- **Acceptance:** A demo screen shows tokenized typography, colors, spacing,
  radii. Toggling system theme swaps both token sets without rebuilding the
  app shell.

### Phase 3 — Motion Tokens, Physics, Transitions
- Implement `MotionTokens`, `SilkScrollPhysics`, `SilkScrollBehavior`,
  `CustomTransitionPage` variants, `Haptics` helper.
- Wire `SilkScrollBehavior` into `MaterialApp.router`.
- **Acceptance:** A demo screen with a long list scrolls with tuned physics;
  pushing/popping a second screen uses the shared-axis transition; modal
  sheet slides in with emphasized motion.

### Phase 4 — Network Layer
- Implement `Result`, `ApiException`, mapper, interceptors, `dioProvider`.
- Add a stub `ApiClient` using retrofit pointing at `https://httpbin.org` so
  the wiring is verifiable.
- **Acceptance:** Calling `apiClient.get(...)` returns a typed `Result`.
  Forcing a 500 in the demo screen surfaces a `ServerException` mapped to
  `AppFailure.server`.

### Phase 5 — Router
- Implement `GoRouter` with redirect logic for unauthenticated routes.
- Add `SilkGestureBack` shell.
- **Acceptance:** Auth redirect works (unauthenticated user pushed to
  `/login`). Edge-swipe back works on both platforms.

### Phase 6 — Silk Widget Layer
- Implement every `Silk*` widget listed in the project structure. Each is a
  composition of Material widgets with the press, theme, motion, and haptics
  rules baked in.
- **Acceptance:** Every Silk widget has at least one `widgetbook` use case
  demonstrating its variants and states. Golden tests pass for each, light
  and dark.

### Phase 7 — Example Feature: Auth
- Build the auth feature end-to-end: phone/email input → OTP → home stub.
- Demonstrates: Riverpod `AsyncNotifier`, Retrofit client, `Result` →
  `AsyncValue`, custom transitions between login screens, Silk widgets only,
  haptics on submit, error UI without spinner flashes.
- **Acceptance:** Full flow runs without any Material widget appearing in
  feature code (verified by grep). Profile a release build on a physical
  device; the flow holds 60fps end-to-end.

### Phase 8 — Docs & Generator
- `README.md` covering: what the template is, how to run it, how to add a
  new feature (with a worked example).
- `docs/architecture.md` explaining the layers and rules.
- `docs/motion.md` explaining the motion token philosophy.
- `tool/new_feature.dart` — a mason brick or simple script that scaffolds
  `features/<name>/{data,domain,presentation}` with stub files matching the
  auth feature's shape.
- **Acceptance:** A new engineer can run the generator, get a working
  feature skeleton, and add a screen without reading anything outside the
  three docs.

---

## Conventions

- **Imports.** Use package imports (`package:silk/...`) everywhere, not
  relative. Linter should enforce.
- **File naming.** `snake_case.dart`. One public class per file unless tightly
  coupled (e.g., `freezed` part files don't count).
- **Provider naming.** `xxxProvider` for providers, `XxxController` for
  notifiers. Use `@riverpod` annotation, not manual declarations.
- **Async boundaries.** Repositories are pure async functions returning
  `Result`. Controllers wrap them and expose `AsyncValue`. Widgets only ever
  see `AsyncValue`.
- **Error UI.** `AsyncValue.whenSmooth` for the standard pattern. Custom error
  widgets only when the failure has a specific recovery action.
- **Tests.** Every repository has unit tests with a mocked Dio. Every Silk
  widget has a golden test. Aim for 70%+ coverage on `core/` and
  `shared/widgets/`.

---

## Anti-Patterns — Do Not Do These

- Do not introduce a new state management library "just for this one screen".
- Do not use `setState` inside Riverpod-aware widgets except for purely local
  UI state (e.g., a TextEditingController focus listener).
- Do not call `Navigator.of(context).push` directly. Use `context.push` from
  `go_router`.
- Do not use `MaterialPageRoute`. All routes go through the custom transition
  pages.
- Do not write motion code with `AnimationController` in a feature widget
  unless the motion is unique to that feature. For anything reusable, add it
  to `core/motion/` or `shared/widgets/`.
- Do not skip the `widgetbook` use case for a new Silk widget. It is part of
  "done".

---

## Open Decisions for the User

Before starting Phase 1, confirm:

1. **Project name and bundle id** (default: `silk`,
   `co.silk.app` — change if this template is for a different
   product line).
2. **Minimum platform versions** (default: iOS 13, Android API 23).
3. **Base accent color** (default: a desaturated indigo `#5B6CF5`) — the
   template author should provide one if branding is known.
4. **Whether to include the `widgetbook` target** as a separate entry point
   from day one, or defer to Phase 6 (default: include from Phase 2 so theme
   work is inspectable).

Ask once at the top of execution, then proceed.

---

## Definition of Done

The template is done when:

- A fresh `flutter run` boots the auth example, walks login → home stub
  smoothly on iOS and Android.
- `flutter analyze` is clean.
- `flutter test` passes including goldens.
- A grep for `Duration(`, `Curves\.`, `Color(0x`, `MaterialButton`,
  `ElevatedButton`, `TextField(`, `BottomSheet(` inside `lib/features/`
  returns zero hits.
- A new engineer can read `README.md` + `architecture.md` + `motion.md` and
  add a new feature without asking architectural questions.
- The widgetbook run target shows every Silk widget in both themes.

That is the bar. Build to it.
