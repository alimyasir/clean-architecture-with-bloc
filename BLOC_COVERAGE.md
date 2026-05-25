# BLoC Coverage Reference

> Project: `clean-architecture-with-bloc`
> Last updated: 2026-05-25
> Packages: `bloc: ^9.0.0` · `flutter_bloc: ^9.0.0` · `bloc_concurrency: ^0.3.0` · `stream_transform: ^2.1.0`

---

## 1. Core BLoC Class

| API | Status | Location |
|-----|--------|----------|
| `Bloc<Event, State>` | ✅ Covered | `product_bloc.dart` |
| `Cubit<State>` | ⛔ Not used (intentional — pure BLoC only) | — |
| `on<Event>(handler)` | ✅ Covered | `product_bloc.dart` |
| `on<Event>(handler, transformer:)` | ✅ Covered | `product_bloc.dart` |
| `emit(state)` | ✅ Covered | `product_bloc.dart` |
| `state` getter | ✅ Covered | `product_bloc.dart` |
| `add(event)` | ✅ Covered | `product_screen.dart`, `main.dart` |
| `addError(error, stackTrace)` | ✅ Covered | `product_bloc.dart` |
| `stream` property | ❌ Pending | — |
| `isClosed` guard | ❌ Pending | — |
| `close()` / disposal | ❌ Pending | — |

---

## 2. BLoC Lifecycle Overrides

| Override | Status | Location |
|----------|--------|----------|
| `onCreate(bloc)` | ✅ Covered | `app_bloc_observer.dart` |
| `onEvent(bloc, event)` | ✅ Covered | `app_bloc_observer.dart` + `product_bloc.dart` |
| `onChange(bloc, change)` | ✅ Covered | `app_bloc_observer.dart` + `product_bloc.dart` |
| `onTransition(bloc, transition)` | ✅ Covered | `app_bloc_observer.dart` + `product_bloc.dart` |
| `onError(bloc, error, stack)` | ✅ Covered | `app_bloc_observer.dart` + `product_bloc.dart` |
| `onClose(bloc)` | ✅ Covered | `app_bloc_observer.dart` |

---

## 3. BlocObserver (Global)

| API | Status | Location |
|-----|--------|----------|
| `BlocObserver` class | ✅ Covered | `lib/core/bloc/app_bloc_observer.dart` |
| `Bloc.observer = ...` (registration) | ✅ Covered | `main.dart` |

---

## 4. Flutter BLoC Widgets

| Widget | Status | Location |
|--------|--------|----------|
| `BlocProvider` | ✅ Covered | `main.dart` |
| `BlocBuilder<B, S>` | ✅ Covered | `product_screen.dart` (via BlocConsumer) |
| `BlocListener<B, S>` | ✅ Covered | `product_screen.dart` (via BlocConsumer) |
| `BlocConsumer<B, S>` | ✅ Covered | `product_screen.dart` |
| `MultiBlocProvider` | ❌ Pending | — |
| `MultiBlocListener` | ❌ Pending | — |
| `RepositoryProvider` | ❌ Pending | — |
| `MultiRepositoryProvider` | ❌ Pending | — |

---

## 5. BlocBuilder / BlocConsumer Options

| Option | Status | Location |
|--------|--------|----------|
| `buildWhen: (prev, curr) =>` | ❌ Pending | — |
| `listenWhen: (prev, curr) =>` | ✅ Covered | `product_screen.dart` |

---

## 6. BuildContext Extensions

| Extension | Status | Location |
|-----------|--------|----------|
| `context.read<B>()` | ✅ Covered | `product_screen.dart` |
| `context.watch<B>()` | ❌ Pending | — |
| `context.select<B, T>()` | ❌ Pending | — |

---

## 7. Event Transformers (`bloc_concurrency`)

| Transformer | Status | Applied To |
|-------------|--------|------------|
| `restartable()` | ✅ Covered | `LoadProductsEvent` |
| `sequential()` | ✅ Covered | `ToggleFavoriteEvent` |
| `droppable()` | ✅ Covered | `FilterByCategoryEvent` |
| `concurrent()` | ❌ Pending | — |
| Custom debounce (via `stream_transform`) | ✅ Covered | `SearchProductsEvent` (300 ms) |

---

## 8. State & Event Design Patterns

| Pattern | Status | Location |
|---------|--------|----------|
| `sealed class` for states | ✅ Covered | `product_state.dart` |
| `sealed class` for events | ✅ Covered | `product_event.dart` |
| `final class` subtypes | ✅ Covered | `product_state.dart`, `product_event.dart` |
| Dart 3 exhaustive `switch` on state | ✅ Covered | `product_screen.dart` |
| `Equatable` on states | ✅ Covered | `product_state.dart` |
| `Equatable` on events | ✅ Covered | `product_event.dart` |
| `copyWith()` on loaded state | ✅ Covered | `product_state.dart` |
| Immutable state (`const` constructors) | ✅ Covered | `product_state.dart` |

---

## 9. Advanced / Ecosystem

| Feature | Status | Notes |
|---------|--------|-------|
| `HydratedBloc` (auto-persist state) | ❌ Pending | Needs `hydrated_bloc` package |
| `ReplayBloc` (undo/redo) | ❌ Pending | Needs `replay_bloc` package |
| `bloc_test` (`blocTest`, `emitsInOrder`) | ❌ Pending | Unit + integration testing |
| `MockBloc` / `MockCubit` | ❌ Pending | Widget testing with `mocktail` |
| `isClosed` guard before `emit` | ❌ Pending | Safety in long-running async handlers |
| `stream.listen()` on bloc | ❌ Pending | Programmatic stream subscription |

---

## 10. Summary

| Category | Covered | Pending | Total |
|----------|---------|---------|-------|
| Core BLoC Class | 8 | 3 | 11 |
| Lifecycle Overrides | 6 | 0 | 6 |
| BlocObserver | 2 | 0 | 2 |
| Flutter Widgets | 4 | 4 | 8 |
| Builder/Consumer Options | 1 | 1 | 2 |
| Context Extensions | 1 | 2 | 3 |
| Event Transformers | 4 | 1 | 5 |
| State/Event Patterns | 8 | 0 | 8 |
| Advanced / Ecosystem | 0 | 6 | 6 |
| **Total** | **34** | **17** | **51** |

> **Coverage: 34 / 51 = 67%**

---

## Next Steps (Priority Order)

1. **`bloc_test`** — add `blocTest()` unit tests; biggest gap for a professional project
2. **`buildWhen`** — prevent grid from rebuilding when only favorites toggle
3. **`context.select`** — subscribe only to the slice of state a widget needs
4. **`HydratedBloc`** — persist `ProductLoaded` state across cold starts
5. **`isClosed` guard** — wrap `emit` calls in long async handlers
6. **`MultiBlocProvider`** — needed once a second BLoC is added to the app
