# OOP Interview Prep — Full Stack Flutter Developer

> Language: Dart · Framework: Flutter · State: BLoC
> All code examples are production-style, not textbook toy examples.

---

## PART 1 — Pure OOP Concepts

---

### 1. Class & Object

A **class** is a blueprint. An **object** is an instance of that blueprint.

```dart
class Product {
  final int id;
  final String title;
  final double price;

  const Product({required this.id, required this.title, required this.price});
}

// Object (instance)
final product = Product(id: 1, title: 'Shoes', price: 49.99);
```

**Interview Q:** What is the difference between a class and an object?
> A class defines structure and behavior. An object is a runtime instance of that class with its own state.

---

### 2. Encapsulation

Hiding internal state. Only expose what the outside world needs.

```dart
class Cart {
  // Private — no one outside can mutate this directly
  final List<Product> _items = [];

  // Public read-only view
  List<Product> get items => List.unmodifiable(_items);
  int get totalCount => _items.length;
  double get totalPrice => _items.fold(0, (sum, p) => sum + p.price);

  void add(Product product) => _items.add(product);
  void remove(Product product) => _items.remove(product);
}
```

**Interview Q:** How does Dart enforce encapsulation?
> With the `_` prefix (library-private). Dart has no `private`/`protected` keywords — privacy is at the library level, not the class level.

---

### 3. Inheritance

A child class **extends** a parent and inherits its members.

```dart
class Animal {
  final String name;
  Animal(this.name);

  String speak() => '...';
}

class Dog extends Animal {
  Dog(super.name); // Dart 3 super-parameter shorthand

  @override
  String speak() => 'Woof!';
}

class Cat extends Animal {
  Cat(super.name);

  @override
  String speak() => 'Meow!';
}
```

**Interview Q:** What is the difference between `extends`, `implements`, and `with`?

| Keyword | Purpose | Can override? | Multiple? |
|---------|---------|---------------|-----------|
| `extends` | Inherit implementation | Yes (`@override`) | No (single) |
| `implements` | Fulfill a contract (no code reuse) | Must implement all | Yes |
| `with` | Mixin — code reuse without inheritance | Yes | Yes |

---

### 4. Polymorphism

Same interface, different behavior depending on the actual type.

```dart
// Runtime polymorphism
List<Animal> animals = [Dog('Rex'), Cat('Luna'), Dog('Bruno')];

for (final animal in animals) {
  print(animal.speak()); // Woof! / Meow! / Woof! — resolved at runtime
}
```

```dart
// Compile-time (generics — ad-hoc polymorphism)
T first<T>(List<T> list) => list.first;
```

**Interview Q:** What is the difference between compile-time and runtime polymorphism in Dart?
> Dart has no method overloading (same name, different params), so compile-time polymorphism is achieved through **generics**. Runtime polymorphism is via **method overriding** with `@override`.

---

### 5. Abstraction

Hide implementation complexity. Expose only what is needed via abstract classes or interfaces.

```dart
// Abstract class = partial implementation allowed
abstract class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product> getById(int id);
}

// Concrete implementation — caller never knows it's HTTP
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  ProductRepositoryImpl(this._remote);

  @override
  Future<List<Product>> getAll() => _remote.fetchProducts();

  @override
  Future<Product> getById(int id) async {
    final all = await _remote.fetchProducts();
    return all.firstWhere((p) => p.id == id);
  }
}
```

**Interview Q:** What is the difference between an abstract class and an interface in Dart?
> Dart has no `interface` keyword. Every class is implicitly an interface. An **abstract class** can have concrete methods and state; an **interface** (any class used with `implements`) forces you to re-implement everything.

---

### 6. Interface (implicit in Dart)

```dart
abstract class Cacheable {
  String get cacheKey;
  Duration get ttl;
}

abstract class Loggable {
  void log(String message);
}

// Implements multiple interfaces
class ApiClient implements Cacheable, Loggable {
  @override
  String get cacheKey => 'api_client';

  @override
  Duration get ttl => const Duration(minutes: 5);

  @override
  void log(String message) => debugPrint('[API] $message');
}
```

---

### 7. Mixins

Reusable code injected into a class without inheritance. Use `mixin`, apply with `with`.

```dart
mixin Timestamps {
  DateTime get createdAt => DateTime.now();
  DateTime get updatedAt => DateTime.now();
}

mixin Validatable {
  bool validate();
}

class Order with Timestamps, Validatable {
  final List<Product> items;
  Order(this.items);

  @override
  bool validate() => items.isNotEmpty;
}
```

**Interview Q:** When do you use a mixin vs an abstract class?
> Use a **mixin** when you want to reuse a behavior across unrelated classes (no "is-a" relationship). Use an **abstract class** when you need shared state or a base constructor.

**Interview Q:** What is `mixin on`?
```dart
mixin Logger on Bloc { // Can only be mixed into Bloc subclasses
  void logState(state) => debugPrint('State: $state');
}
```

---

### 8. Constructors — All Types

```dart
class User {
  final String name;
  final String email;
  final String role;

  // 1. Default / generative
  User(this.name, this.email, this.role);

  // 2. Named constructor
  User.guest() : name = 'Guest', email = '', role = 'viewer';

  // 3. Factory constructor — can return cached / subtype instance
  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'], json['email'], json['role']);
  }

  // 4. Const constructor — compile-time constant
  const User.system()
      : name = 'System',
        email = 'system@app.com',
        role = 'admin';

  // 5. Redirecting constructor
  User.admin(String name, String email) : this(name, email, 'admin');
}
```

**Interview Q:** What is the difference between a factory constructor and a generative constructor?
> A **generative** constructor always creates a new instance. A **factory** constructor can return an existing instance (e.g., singleton), a subtype, or perform computation before deciding what to return.

---

### 9. Getters & Setters

```dart
class Temperature {
  double _celsius;

  Temperature(this._celsius);

  double get celsius => _celsius;
  double get fahrenheit => _celsius * 9 / 5 + 32;

  set celsius(double value) {
    if (value < -273.15) throw ArgumentError('Below absolute zero');
    _celsius = value;
  }
}
```

---

### 10. Static Members

Belong to the class, not an instance.

```dart
class AppConfig {
  static const String baseUrl = 'https://api.example.com';
  static int _instanceCount = 0;

  AppConfig() {
    _instanceCount++;
  }

  static int get instanceCount => _instanceCount;

  // Static factory
  static AppConfig create() => AppConfig();
}
```

---

### 11. `final` vs `const` vs `late`

| Keyword | Set when | Reassignable | Compile-time |
|---------|----------|--------------|--------------|
| `var` | Anytime | Yes | No |
| `final` | Once, at runtime | No | No |
| `const` | Compile time | No | Yes |
| `late` | First access | No (if final) | No |

```dart
const pi = 3.14159;                    // compile-time constant
final launch = DateTime.now();         // runtime constant
late final String config;              // initialized on first use

late String _token;                    // initialized before use, can be set once
```

**Interview Q:** When would you use `late`?
> When a value cannot be initialized at declaration time but you can guarantee it's set before first use — e.g., inside `initState()` or from DI. Avoids nullable types unnecessarily.

---

### 12. Generics

Type-safe containers and functions without code duplication.

```dart
// Generic class
class Result<T> {
  final T? data;
  final String? error;

  const Result.success(this.data) : error = null;
  const Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
}

// Usage
Result<List<Product>> result = await fetchProducts();
if (result.isSuccess) show(result.data!);
```

**Interview Q:** What is the difference between `T`, `T extends X`, and `T?`?
```dart
T identity<T>(T value) => value;              // any type
T clamp<T extends num>(T v, T min, T max) => ...;  // constrained to num
T? maybeFind<T>(List<T> list, bool Function(T) test) => ...;  // nullable return
```

---

### 13. Extension Methods

Add behavior to existing classes without subclassing.

```dart
extension StringX on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  bool get isEmail => contains('@') && contains('.');
}

extension PriceX on double {
  String toUSD() => '\$${toStringAsFixed(2)}';
}

// Usage
'hello'.capitalize();  // 'Hello'
49.9.toUSD();          // '$49.90'
```

---

### 14. Sealed Classes (Dart 3)

A sealed class is `abstract` + closed — all subtypes must be in the same file. Enables exhaustive switch with compiler enforcement.

```dart
sealed class AuthState {}

final class Unauthenticated extends AuthState {}
final class Authenticating extends AuthState {}
final class Authenticated extends AuthState {
  final String userId;
  Authenticated(this.userId);
}
final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// Compiler error if a case is missing
String describe(AuthState state) => switch (state) {
  Unauthenticated() => 'Please log in',
  Authenticating()  => 'Logging in...',
  Authenticated(userId: final id) => 'Welcome, $id',
  AuthError(message: final msg)   => 'Error: $msg',
};
```

---

### 15. Enums (Enhanced — Dart 2.17+)

```dart
enum UserRole {
  admin(label: 'Administrator', canDelete: true),
  editor(label: 'Editor', canDelete: false),
  viewer(label: 'Viewer', canDelete: false);

  final String label;
  final bool canDelete;

  const UserRole({required this.label, required this.canDelete});
}

// Usage
UserRole.admin.label;       // 'Administrator'
UserRole.viewer.canDelete;  // false
```

---

### 16. SOLID Principles (with Dart examples)

| Principle | Definition | Dart Example |
|-----------|------------|--------------|
| **S** — Single Responsibility | One class, one reason to change | `ProductRepository` only fetches. `ProductBloc` only manages state. |
| **O** — Open/Closed | Open for extension, closed for modification | Add `CacheProductRepository` wrapping `ProductRepositoryImpl` without changing it |
| **L** — Liskov Substitution | Subtypes must be substitutable for their base | `ProductRepositoryImpl` can replace `ProductRepository` anywhere |
| **I** — Interface Segregation | Many specific interfaces > one fat interface | `Cacheable`, `Loggable`, `Validatable` — each focused |
| **D** — Dependency Inversion | Depend on abstractions, not concretions | `ProductBloc` depends on `GetProductUseCase`, not `ProductRepositoryImpl` |

```dart
// DIP in practice — BLoC depends on use case abstraction
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase getProductUseCase; // abstraction, not impl
  ProductBloc(this.getProductUseCase) : super(const ProductInitial());
}
```

---

### 17. Design Patterns Used in Flutter/BLoC

#### Singleton
```dart
// GetIt service locator — one instance globally
final sl = GetIt.instance;
sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
```

#### Factory
```dart
// Factory constructor — controls instantiation
factory ProductModel.fromJson(Map<String, dynamic> json) =>
    _$ProductModelFromJson(json);

// GetIt factory — fresh instance per request
sl.registerFactory(() => ProductBloc(sl()));
```

#### Repository
```dart
// Abstracts data source from domain
abstract class ProductRepository {
  Future<List<Product>> getAll();
}
// Domain layer never knows if data comes from API, cache, or DB
```

#### Observer
```dart
// BlocObserver observes all BLoC instances globally
class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) { ... }
}
Bloc.observer = const AppBlocObserver();
```

#### Strategy
```dart
// Event transformer = strategy for processing an event stream
on<SearchProductsEvent>(_onSearch, transformer: _debounce(300.ms));
on<LoadProductsEvent>(_onLoad,   transformer: restartable());
on<ToggleFavoriteEvent>(_onFav,  transformer: sequential());
```

#### Template Method
```dart
// BlocBase defines the algorithm skeleton; subclasses fill steps
abstract class Bloc<E, S> extends BlocBase<S> {
  void on<E>(EventHandler<E, S> handler, {EventTransformer<E>? transformer});
}
// ProductBloc fills in the concrete handlers
```

---

## PART 2 — OOP + BLoC Patterns

---

### 18. How BLoC Uses OOP

```
BlocBase<S>          ← abstract base (encapsulates stream + state)
   └── Bloc<E, S>    ← abstract (adds event processing)
         └── ProductBloc  ← concrete (your implementation)
```

Every OOP pillar appears in BLoC:

| Pillar | Where in BLoC |
|--------|---------------|
| **Encapsulation** | `_allProducts`, `_favorites` are private in `ProductBloc` |
| **Inheritance** | `ProductBloc extends Bloc<ProductEvent, ProductState>` |
| **Abstraction** | `Bloc<E,S>` is abstract — you can't instantiate it directly |
| **Polymorphism** | `switch (state)` handles `ProductLoaded`, `ProductError`, etc. differently |

---

### 19. Event Hierarchy (sealed + final)

```dart
sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

final class LoadProductsEvent  extends ProductEvent { ... }
final class ToggleFavoriteEvent extends ProductEvent { ... }
final class FilterByCategoryEvent extends ProductEvent { ... }
final class SearchProductsEvent extends ProductEvent { ... }
```

**Interview Q:** Why use `sealed` for BLoC events?
> It makes the event hierarchy **closed** — no new events can be added outside the file. Combined with exhaustive `switch`, the compiler tells you if a new event type is unhandled anywhere.

---

### 20. State Hierarchy (sealed + copyWith)

```dart
sealed class ProductState extends Equatable { const ProductState(); }

final class ProductInitial extends ProductState { const ProductInitial(); }
final class ProductLoading extends ProductState { const ProductLoading(); }

final class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<int> favorites;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;

  const ProductLoaded({ ... });

  // Immutable update — returns new instance, never mutates
  ProductLoaded copyWith({ ... });
}

final class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
}
```

**Interview Q:** Why are BLoC states immutable?
> Mutable states break `Equatable` comparison and can cause missed UI updates. Immutability also makes debugging trivial — every state change is a new object with a clear before/after.

---

### 21. Equatable — Value Equality

```dart
// Without Equatable
ProductLoaded(products: [...]) == ProductLoaded(products: [...]) // false (different objects)

// With Equatable + correct props
class ProductLoaded extends ProductState {
  @override
  List<Object?> get props => [products, favorites, selectedCategory, categories, searchQuery];
}
// Now BLoC skips emit if nothing actually changed — prevents unnecessary rebuilds
```

**Interview Q:** What happens if you forget to include a field in `props`?
> BLoC thinks the state didn't change and **won't rebuild** the UI even if that field changed. Always include every field that should trigger a rebuild.

---

### 22. Abstract Class as Contract (Repository Pattern)

```dart
// Domain layer — pure Dart, no Flutter, no http
abstract class ProductRepository {
  Future<List<Product>> getAll();
}

// Data layer — knows about HTTP, JSON
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  ProductRepositoryImpl(this._remote);

  @override
  Future<List<Product>> getAll() => _remote.fetchProducts();
}

// BLoC never imports ProductRepositoryImpl — only the abstraction
class GetProductUseCase {
  final ProductRepository repository;
  GetProductUseCase(this.repository);
  Future<List<Product>> call() => repository.getAll();
}
```

---

### 23. Factory Constructor in DI

```dart
// registerFactory = new instance per call (correct for BLoC)
sl.registerFactory(() => ProductBloc(sl()));

// registerLazySingleton = one instance, created on first use
sl.registerLazySingleton(() => GetProductUseCase(sl()));
```

**Interview Q:** Why register BLoC as Factory, not Singleton?
> BLoC holds UI state. A singleton BLoC would share state across all screens and navigation pushes, causing stale data. A factory creates a fresh BLoC (clean state) each time a `BlocProvider` asks for one.

---

### 24. Polymorphism in BlocConsumer

```dart
// Same widget slot, different concrete widget resolved at runtime
builder: (context, state) => switch (state) {
  ProductInitial() => const SizedBox.shrink(),
  ProductLoading() => const _ShimmerGrid(),
  ProductLoaded()  => _ProductContent(state: state),
  ProductError()   => _ErrorView(message: state.message),
},
```

This is **runtime polymorphism** — the same `builder` returns a different widget based on the actual runtime type of `state`.

---

### 25. Strategy Pattern — Event Transformers

```dart
// Each event type gets a different processing strategy
on<LoadProductsEvent>(_onLoad,    transformer: restartable()); // cancel old, start new
on<ToggleFavoriteEvent>(_onFav,   transformer: sequential());  // queue, never overlap
on<FilterByCategoryEvent>(_onFilter, transformer: droppable()); // ignore if busy
on<SearchProductsEvent>(_onSearch, transformer: _debounce(300.ms)); // wait for pause
```

**Interview Q:** Why does `ToggleFavoriteEvent` use `sequential()` but `LoadProductsEvent` uses `restartable()`?
> Favorites write to `SharedPreferences`. If two writes overlap, data can corrupt — `sequential()` queues them safely. A load triggered twice (e.g., pull-to-refresh mid-load) should cancel the first request and start fresh — that's `restartable()`.

---

### 26. Observer Pattern — BlocObserver

```dart
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    appLog('[BLoC] ${bloc.runtimeType}: $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stack) {
    appLog('[BLoC] ERROR ${bloc.runtimeType}: $error');
    super.onError(bloc, error, stack);
  }
}

// Registered once, observes ALL BLoCs in the app
Bloc.observer = const AppBlocObserver();
```

---

### 27. Template Method Pattern in BLoC

`Bloc<E, S>` defines the processing algorithm. You fill in the steps via `on<E>()`.

```dart
// Framework (template):
// 1. Receive event
// 2. Apply transformer
// 3. Call your handler
// 4. Emit new state if changed

// Your code fills step 3:
on<LoadProductsEvent>((event, emit) async {
  emit(const ProductLoading());          // step 3a
  final products = await useCase();      // step 3b
  emit(ProductLoaded(products: products, ...)); // step 3c
});
```

---

## PART 3 — Common Interview Questions

---

### Quick-Fire OOP

| Question | One-Line Answer |
|----------|----------------|
| What is OOP? | Modeling code as objects with state (fields) and behavior (methods) |
| What are the 4 pillars? | Encapsulation, Inheritance, Polymorphism, Abstraction |
| Dart has multiple inheritance? | No — single `extends`, multiple `implements`, multiple `with` |
| What is `@override`? | Annotation that tells the compiler you intend to override a parent method — catches typos |
| Can a `const` object be modified? | No — `const` is deeply immutable at compile time |
| What does `final` mean on a class? | Class cannot be subclassed (equivalent to Java `final class`) |
| What is a mixin? | A way to reuse code across classes without inheritance |
| What is a factory constructor for? | Controlling instantiation — can return a cached instance, a subtype, or a computed value |
| What is covariant? | Allows overriding a method parameter to be a subtype of the original |
| What is `late`? | Defers initialization — tells Dart "trust me, it will be set before use" |

---

### Quick-Fire BLoC + OOP

| Question | One-Line Answer |
|----------|----------------|
| Why does `Bloc` extend `BlocBase`? | Inheritance — reuses stream management, `state` getter, `close()`, error handling |
| Why use `sealed` for states? | Closed hierarchy + exhaustive compiler-checked `switch` |
| What is `emit`? | Method that pushes a new state to the stream — only callable inside a handler |
| Why are states immutable? | Equatable equality check; predictable rebuild behavior; easy time-travel debugging |
| Difference between `Bloc` and `Cubit`? | `Cubit` exposes methods; `Bloc` uses explicit events — BLoC is more traceable |
| What does `addError` do? | Routes an error through `onError` lifecycle and the global `BlocObserver` |
| When does BLoC NOT rebuild the UI? | When `emit` is called with a state equal (via Equatable) to the current state |
| What is `buildWhen`? | Predicate in `BlocBuilder` — controls when the widget should rebuild |
| What is `listenWhen`? | Predicate in `BlocListener` — controls when the listener callback fires |
| Why register BLoC as `registerFactory`? | Fresh state per screen; singletons cause stale state across navigations |

---

## Coverage Checklist

### OOP Concepts

| Topic | Understood | Can Code It | Can Explain Trade-offs |
|-------|------------|-------------|------------------------|
| Class & Object | ☐ | ☐ | ☐ |
| Encapsulation | ☐ | ☐ | ☐ |
| Inheritance (`extends`) | ☐ | ☐ | ☐ |
| Abstraction (abstract class) | ☐ | ☐ | ☐ |
| Interface (`implements`) | ☐ | ☐ | ☐ |
| Polymorphism | ☐ | ☐ | ☐ |
| Mixins (`with`) | ☐ | ☐ | ☐ |
| All constructor types | ☐ | ☐ | ☐ |
| Getters & Setters | ☐ | ☐ | ☐ |
| `final` / `const` / `late` | ☐ | ☐ | ☐ |
| Generics | ☐ | ☐ | ☐ |
| Extension methods | ☐ | ☐ | ☐ |
| Sealed classes (Dart 3) | ☐ | ☐ | ☐ |
| Enhanced Enums (Dart 2.17+) | ☐ | ☐ | ☐ |
| SOLID principles | ☐ | ☐ | ☐ |
| Singleton pattern | ☐ | ☐ | ☐ |
| Factory pattern | ☐ | ☐ | ☐ |
| Repository pattern | ☐ | ☐ | ☐ |
| Observer pattern | ☐ | ☐ | ☐ |
| Strategy pattern | ☐ | ☐ | ☐ |

### OOP + BLoC

| Topic | Understood | Can Code It | Can Explain Trade-offs |
|-------|------------|-------------|------------------------|
| Bloc inheritance chain | ☐ | ☐ | ☐ |
| Sealed events & states | ☐ | ☐ | ☐ |
| Equatable & `props` | ☐ | ☐ | ☐ |
| `copyWith` pattern | ☐ | ☐ | ☐ |
| Event transformers | ☐ | ☐ | ☐ |
| BlocObserver (Observer pattern) | ☐ | ☐ | ☐ |
| Repository pattern in Clean Arch | ☐ | ☐ | ☐ |
| Factory vs Singleton in DI | ☐ | ☐ | ☐ |
| BlocBuilder / BlocConsumer | ☐ | ☐ | ☐ |
| `buildWhen` / `listenWhen` | ☐ | ☐ | ☐ |
| `addError` + `onError` flow | ☐ | ☐ | ☐ |
| Strategy pattern (transformers) | ☐ | ☐ | ☐ |
