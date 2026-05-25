import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clean_architecture_with_bloc/domain/entities/product.dart';
import 'package:clean_architecture_with_bloc/domain/usecases/get_products_usecase.dart';
import 'package:clean_architecture_with_bloc/presentation/post_screen/bloc/product_event.dart';
import 'package:clean_architecture_with_bloc/presentation/post_screen/bloc/product_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase getProductUseCase;
  static const _favoritesKey = 'favorites';

  List<Product> _allProducts = [];
  List<int> _favorites = [];

  ProductBloc(this.getProductUseCase) : super(const ProductInitial()) {
    // restartable: cancels in-flight load if another LoadProductsEvent arrives
    on<LoadProductsEvent>(_onLoadProducts, transformer: restartable());

    // sequential: favorite writes are queued, never concurrent
    on<ToggleFavoriteEvent>(_onToggleFavorite, transformer: sequential());

    // droppable: ignores new filter events while one is processing
    on<FilterByCategoryEvent>(_onFilterCategory, transformer: droppable());

    // debounce 300 ms so we don't search on every keystroke
    on<SearchProductsEvent>(
      _onSearchProducts,
      transformer: _debounce(const Duration(milliseconds: 300)),
    );
  }

  // ── BLoC lifecycle overrides (observed globally by AppBlocObserver) ──────

  @override
  void onEvent(ProductEvent event) {
    super.onEvent(event);
  }

  @override
  void onChange(Change<ProductState> change) {
    super.onChange(change);
  }

  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  // ── Event handlers ───────────────────────────────────────────────────────

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      await _loadFavorites();
      final products = await getProductUseCase();
      _allProducts = products;
      final categories = products.map((p) => p.category).toSet().toList();
      emit(ProductLoaded(
        products: products,
        favorites: List<int>.from(_favorites),
        categories: categories,
      ));
    } catch (e, stackTrace) {
      addError(e, stackTrace); // routes through onError → AppBlocObserver
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (_favorites.contains(event.productId)) {
      _favorites.remove(event.productId);
    } else {
      _favorites.add(event.productId);
    }
    await _saveFavorites();

    if (state is ProductLoaded) {
      // copyWith preserves selectedCategory, categories, searchQuery
      emit((state as ProductLoaded).copyWith(favorites: List<int>.from(_favorites)));
    }
  }

  void _onFilterCategory(
    FilterByCategoryEvent event,
    Emitter<ProductState> emit,
  ) {
    if (state is! ProductLoaded) return;
    final current = state as ProductLoaded;

    if (event.category == null) {
      // Reset to full list — no network call needed
      emit(current.copyWith(
        products: _allProducts,
        clearCategory: true,
        searchQuery: '',
      ));
      return;
    }

    final filtered = _allProducts
        .where((p) => p.category == event.category)
        .toList();

    emit(current.copyWith(
      products: filtered,
      selectedCategory: event.category,
      searchQuery: '',
    ));
  }

  void _onSearchProducts(
    SearchProductsEvent event,
    Emitter<ProductState> emit,
  ) {
    if (state is! ProductLoaded) return;
    final current = state as ProductLoaded;

    // Respect any active category filter as the search base
    final base = current.selectedCategory != null
        ? _allProducts.where((p) => p.category == current.selectedCategory).toList()
        : _allProducts;

    final filtered = event.query.isEmpty
        ? base
        : base
            .where((p) => p.title.toLowerCase().contains(event.query.toLowerCase()))
            .toList();

    emit(current.copyWith(products: filtered, searchQuery: event.query));
  }

  // ── SharedPreferences helpers ────────────────────────────────────────────

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_favoritesKey) ?? [];
    _favorites = stored.map(int.parse).toList();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _favoritesKey,
      _favorites.map((id) => id.toString()).toList(),
    );
  }
}
