import 'package:clean_architecture_with_bloc/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

final class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<int> favorites;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;

  const ProductLoaded({
    required this.products,
    required this.favorites,
    required this.categories,
    this.selectedCategory,
    this.searchQuery = '',
  });

  ProductLoaded copyWith({
    List<Product>? products,
    List<int>? favorites,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    bool clearCategory = false,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      favorites: favorites ?? this.favorites,
      categories: categories ?? this.categories,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [products, favorites, categories, selectedCategory, searchQuery];
}

final class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
