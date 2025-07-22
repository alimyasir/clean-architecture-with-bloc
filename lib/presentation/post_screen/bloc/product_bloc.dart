import 'package:bloc/bloc.dart';
import 'package:clean_architecture_with_bloc/domain/entities/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clean_architecture_with_bloc/domain/usecases/get_products_usecase.dart';
import 'package:clean_architecture_with_bloc/presentation/post_screen/bloc/product_event.dart';
import 'package:clean_architecture_with_bloc/presentation/post_screen/bloc/product_state.dart';

class PostBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase getPostsUseCase;
  static const _favoritesKey = 'favorites';

  List<int> _favorites = [];
  List<Product> _allProducts = []; // This will hold all products


  PostBloc(this.getPostsUseCase) : super(ProductInitial()) {
    _init();
    on<LoadProductsEvent>(_onLoadProducts);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<FilterByCategoryEvent>(_onFilterCategory);
  }

  void _onFilterCategory(
      FilterByCategoryEvent event,
      Emitter<ProductState> emit,
      ) {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;

      final filtered = _allProducts
          .where((product) => product.category == event.category)
          .toList();

      emit(ProductLoaded(
        filtered,
        currentState.favorites,
        selectedCategory: event.category,
        categories: currentState.categories,
      ));
    }
  }




  Future<void> _init() async {
    await _loadFavorites();
  }

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

  Future<void> _onLoadProducts(
      LoadProductsEvent event,
      Emitter<ProductState> emit,
      ) async {
    emit(ProductLoading());
    try {
      await _loadFavorites();
      final products = await getPostsUseCase();

      _allProducts = products; // Save original list

      final categories = products.map((p) => p.category).toSet().toList();

      emit(ProductLoaded(
        products,
        _favorites,
        categories: categories,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }



  void _onToggleFavorite(
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
      emit(ProductLoaded(
        (state as ProductLoaded).products,
        _favorites,
      ));
    }
  }
}
