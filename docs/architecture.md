# Architecture

## Layer model

Each feature follows a strict three-layer model. Layers only depend downward — presentation → domain → data.

```
presentation/
  screens/        ConsumerStatefulWidget / ConsumerWidget pages
  widgets/        Feature-private Silk* compositions
  providers/      Riverpod controllers and selectors

domain/
  <entity>.dart   Freezed value objects; no Flutter imports

data/
  models/         Freezed JSON models (fromJson/toJson)
  <feature>_api.dart      Plain Dio client; maps HTTP ↔ domain models
  <feature>_repository.dart  Returns Result<T, AppFailure>; catches ApiException
```

### Presentation

- Screens watch providers with `ref.watch`. Side-effects use `ref.listen`.
- Controllers extend `_$<Name>` (riverpod_generator). State is `AsyncValue<T>` or `T`.
- Never call repository directly from a widget. Always go through a controller or selector provider.
- All async operations return `AsyncValue` — no raw `Future` state in widgets.

### Domain

- Entities are `@freezed abstract class` with no dependencies on Flutter or Dio.
- `Result<T, AppFailure>` is the universal return type for fallible operations.

### Data

- API classes take a `Dio` instance (injected via `ref.watch(dioProvider)`).
- Repositories catch `DioException`, map through `DioExceptionMapper` → `ApiException` → `FailureMapper` → `AppFailure`, and return `Result`.
- Never throw from a repository — always return `Result.failure(...)`.

## Result type

```dart
// Result<T, E> is a sealed freezed type.
// .when() comes from the generated ResultPatterns extension — import result.dart.
final result = await ref.read(someRepositoryProvider).doSomething();
result.when(
  success: (value) { /* ... */ },
  failure: (AppFailure e) { state = AsyncValue.error(e, StackTrace.current); },
);
```

## Providers

All providers use `@riverpod` (codegen-first). No manual `Provider(...)` declarations.

| Annotation                      | Use case                                      |
| ------------------------------- | --------------------------------------------- |
| `@riverpod`                     | Scoped, auto-disposed                         |
| `@Riverpod(keepAlive: true)`    | Singletons: router, dio, session              |
| `class Foo extends _$Foo`       | Mutable controllers with `AsyncValue` state   |

Run `dart run build_runner build --delete-conflicting-outputs` after adding or changing any annotated provider.

## Error handling

```
DioException
  → DioExceptionMapper.map()   → ApiException (network/server shape)
  → FailureMapper.from()       → AppFailure   (user-facing shape)
```

`AppFailure` has a `userMessage` getter. Display that directly to the user. Never show raw error messages.

## Storage

`KeyValueStore` is the abstraction. Two implementations:

- `SecureStore` — `flutter_secure_storage`. Use for tokens, credentials.
- `PrefsStore` — `shared_preferences`. Use for UI state, settings.

Keys live in `StorageKeys` constants. Never use raw string keys.

## Navigation

Routes are defined in `app_router.dart` (single file). Page transitions are injected at the route level:

| Route family            | Transition class    | Motion feel                     |
| ----------------------- | ------------------- | ------------------------------- |
| Push (peer screens)     | `SharedAxisPage`    | Horizontal shared-axis          |
| Modal / bottom sheet    | `ModalPage`         | Slide-up with dim backdrop      |
| Tab / replace           | `FadePage`          | Fade-through                    |

`SilkGestureBack` wraps every screen to handle back gestures natively on both platforms.

## Code generation

Three generators run via `build_runner`:

| Generator          | Input annotation              | Output              |
| ------------------ | ----------------------------- | ------------------- |
| `freezed`          | `@freezed`                    | `.freezed.dart`     |
| `json_serializable`| `factory X.fromJson(...)`     | `.g.dart`           |
| `riverpod_generator`| `@riverpod` / `@Riverpod`    | `.g.dart`           |

Generated files are excluded from analysis (`analysis_options.yaml`) and should not be edited manually. Commit them — they are deterministic.
