import 'package:equatable/equatable.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProductsEvent extends ProductEvent {
  const LoadProductsEvent();
}

final class ToggleFavoriteEvent extends ProductEvent {
  final int productId;

  const ToggleFavoriteEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// [category] == null resets to "All Categories" without re-fetching.
final class FilterByCategoryEvent extends ProductEvent {
  final String? category;

  const FilterByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

/// Dispatched on every keystroke; debounced inside the BLoC.
final class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
