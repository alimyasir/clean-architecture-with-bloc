

import 'package:clean_architecture_with_bloc/data/datasources/product_remote_data_source.dart';
import 'package:clean_architecture_with_bloc/domain/entities/product.dart';
import 'package:clean_architecture_with_bloc/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Product>> getPosts() async {
    return await remoteDataSource.getPosts();
  }
}