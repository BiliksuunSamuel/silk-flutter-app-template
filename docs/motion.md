# Motion

## Principle

Every animation communicates intent. Durations and curves are not aesthetic choices — they encode the semantic weight of a transition. An element that disappears permanently moves differently from one that slides off-screen and can come back.

Never hardcode a `Duration(...)` or a `Curves.*` value in feature code. All motion values come from `MotionTokens`.

## Durations

| Token                    | Value  | Use                                                        |
| ------------------------ | ------ | ---------------------------------------------------------- |
| `MotionTokens.micro`     | 100ms  | Immediate feedback: press states, checkbox toggles         |
| `MotionTokens.fast`      | 180ms  | Small element entrances, icon swaps, badge updates         |
| `MotionTokens.standard`  | 240ms  | Default. Most screen-level widget transitions              |
| `MotionTokens.emphasized`| 320ms  | Screen-level navigation, modal sheets                      |
| `MotionTokens.slow`      | 480ms  | Hero images, onboarding reveals — use sparingly            |

## Curves

| Token                         | Cubic                    | Use                                          |
| ----------------------------- | ------------------------ | -------------------------------------------- |
| `MotionTokens.standardCurve`  | `easeOutCubic`           | Default for most element transitions         |
| `MotionTokens.emphasizedDecel`| `(0.05, 0.7, 0.1, 1)`   | Elements entering the screen (decelerating)  |
| `MotionTokens.emphasizedAccel`| `(0.3, 0, 0.8, 0.15)`   | Elements leaving the screen (accelerating)   |
| `MotionTokens.sharp`          | `(0.4, 0, 0.6, 1)`      | Press feedback, state snaps                  |

## Springs

| Token                    | mass / stiffness / damping | Use                                     |
| ------------------------ | -------------------------- | --------------------------------------- |
| `MotionTokens.bouncy`    | 1 / 420 / 28               | Sheets, FABs — spring with slight overshoot |
| `MotionTokens.gentle`    | 1 / 280 / 24               | Softer spring, no visible overshoot     |

## Press animation pattern

Every tappable `Silk*` widget uses this exact pattern — do not deviate:

```dart
AnimatedScale(
  scale: _pressed ? 0.96 : 1.0,
  duration: MotionTokens.micro,
  curve: MotionTokens.sharp,
  child: AnimatedOpacity(
    opacity: _pressed ? 0.80 : 1.0,
    duration: MotionTokens.micro,
    curve: MotionTokens.sharp,
    child: /* actual widget */,
  ),
)
```

The `GestureDetector` sets `_pressed` on `onTapDown` / `onTapUp` / `onTapCancel`.

## Page transitions

| Situation                | Use                         | Files                                    |
| ------------------------ | --------------------------- | ---------------------------------------- |
| Navigating forward       | `SharedAxisPage`            | `core/router/transitions/shared_axis_page.dart` |
| Modal / bottom sheet     | `ModalPage`                 | `core/router/transitions/modal_page.dart` |
| Root tab replacement     | `FadePage`                  | `core/router/transitions/fade_page.dart`  |

Assign the transition at the route definition level in `app_router.dart`, not inside the screen widget.

## Scroll physics

`SilkScrollPhysics` is applied app-wide via `SilkScrollBehavior`. It uses:

- `minFlingVelocity: 50` — lower than the default 50 to pick up light flicks
- Custom spring: `mass 0.5 / stiffness 120 / damping 1.1` — slightly bouncier than iOS default
- `dragStartDistanceMotionThreshold: 3.5` — more responsive to scroll initiation

Do not override physics per-`ListView` unless there is a product reason. Consistent physics across the app is part of the "feels native" goal.

## Smooth async state — `whenSmooth`

The `AsyncValue.whenSmooth()` extension prevents jarring loader flashes when data refreshes. During a reload it shows the previous data with a shimmer overlay, transitioning to the new data when it arrives. Use it on any list or content screen that can refresh.

```dart
ref.watch(feedProvider).whenSmooth(
  data: (items) => FeedList(items: items),
  loading: () => FeedShimmer(),
  error: (e, _) => ErrorView(message: e.userMessage),
);
```

## Haptics

Pair animations with haptics for physical realism:

```dart
Haptics.light();     // Taps, selections
Haptics.medium();    // Confirmations, toggles
Haptics.heavy();     // Destructive actions, alerts
Haptics.selection(); // Picker scrolling, segment changes
```

Call haptics at gesture start (`onTapDown`), not on completion.
