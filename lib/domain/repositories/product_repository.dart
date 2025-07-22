import 'package:clean_architecture_with_bloc/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getPosts();
}