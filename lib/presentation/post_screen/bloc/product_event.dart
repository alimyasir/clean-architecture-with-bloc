import 'package:clean_architecture_with_bloc/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {}

class ToggleFavoriteEvent extends ProductEvent {
  final int productId;

  ToggleFavoriteEvent(this.productId);
}

class FilterByCategoryEvent extends ProductEvent {
  final String category;

  FilterByCategoryEvent(this.category);
}
