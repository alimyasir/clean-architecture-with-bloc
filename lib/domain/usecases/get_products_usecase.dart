

import 'package:clean_architecture_with_bloc/domain/entities/product.dart';
import 'package:clean_architecture_with_bloc/domain/repositories/product_repository.dart';

class GetProductUseCase {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  Future<List<Product>> call() async {
    return await repository.getPosts();
  }
}