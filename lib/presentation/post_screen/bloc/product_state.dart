
import 'package:clean_architecture_with_bloc/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<int> favorites;
  final String? selectedCategory; // null means "All"
  final List<String> categories;

  const ProductLoaded(
      this.products,
      this.favorites, {
        this.selectedCategory,
        this.categories = const [],
      });

  ProductLoaded copyWith({
    List<Product>? products,
    List<int>? favorites,
    String? selectedCategory,
    List<String>? categories,
  }) {
    return ProductLoaded(
      products ?? this.products,
      favorites ?? this.favorites,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [products, favorites, selectedCategory, categories];
}


class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
