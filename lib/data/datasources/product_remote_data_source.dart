


import 'dart:convert';

import 'package:clean_architecture_with_bloc/core/network/api_service.dart';
import 'package:clean_architecture_with_bloc/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getPosts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<ProductModel>> getPosts() async {
    final response = await ApiService.get('/products');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }
  }
}