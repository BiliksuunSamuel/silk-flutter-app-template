# Silk — Flutter App Template

A production-ready Flutter template targeting Telegram-grade UI smoothness. Every architectural decision is locked in so feature authors focus on product logic, not infrastructure.

## Quick start

```bash
# Install dependencies
flutter pub get

# Generate code (freezed, riverpod, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run widgetbook
flutter run -t widgetbook/main.dart

# Run tests
flutter test

# Static analysis (must be clean)
flutter analyze
```

## Non-negotiables

1. **No literal `Duration(...)` or `Curves.*` in feature code.** Use `MotionTokens`.
2. **No hardcoded colors, spacings, radii, or text styles.** Use `context.tokens`.
3. **No direct `ElevatedButton`, `TextField`, `BottomSheet`, `ListTile` in features.** Use `Silk*` widgets.
4. **No `FutureBuilder` or `Future + setState` for async UI.** Use Riverpod `AsyncValue`.
5. **No `if (isDark) ... else ...` branches.** Dark mode is a second token set — same widget code.
6. **No `print()` calls.** Use `AppLogger`.
7. **No `MaterialApp.router` without `SilkScrollBehavior`.**
8. **Every `Silk*` widget has a widgetbook use case.**

## Project structure

```
lib/
  main.dart                              Bootstrap: ProviderScope + runApp
  app/
    app.dart                             Root MaterialApp.router
    bootstrap.dart                       Async init
    scroll_behavior.dart                 Custom ScrollBehavior
  core/
    theme/                               AppTokens + light/dark instances + ThemeBuilder
    motion/                              MotionTokens, SilkScrollPhysics, Haptics
    network/                             Result<T,E>, ApiException, interceptors, dioProvider
    error/                               AppFailure sealed type + FailureMapper
    router/                              GoRouter + route paths + page transitions
    storage/                             KeyValueStore abstraction (secure + prefs)
    logging/                             AppLogger
  shared/
    widgets/                             Silk* widget layer
    extensions/                          BuildContext + AsyncValue extensions
  features/
    auth/                                Auth feature (login + OTP + session)
    home/                                Home stub
widgetbook/                              Visual widget catalog
```

## Adding a new feature

```bash
dart run tool/new_feature.dart <feature_name>
```

Creates the standard feature slice: `data/`, `domain/`, `presentation/providers/`, `presentation/screens/`, `presentation/widgets/`.

See [docs/architecture.md](docs/architecture.md) for layer contracts and [docs/motion.md](docs/motion.md) for motion guidelines.

## Tech stack

| Concern        | Package                                         |
| -------------- | ----------------------------------------------- |
| State          | `flutter_riverpod` + `riverpod_generator`       |
| Navigation     | `go_router` + custom `CustomTransitionPage`s    |
| HTTP           | `dio` + typed client classes                    |
| Serialization  | `freezed` + `json_serializable`                 |
| Storage        | `flutter_secure_storage` + `shared_preferences` |
| Animation      | `flutter_animate` + `animations`                |
| Images         | `cached_network_image`                          |
| Haptics        | `HapticFeedback` wrapped in `Haptics`           |
| Logging        | `logger` wrapped in `AppLogger`                 |
| Lints          | `very_good_analysis`                            |
| Widget catalog | `widgetbook`                                    |
