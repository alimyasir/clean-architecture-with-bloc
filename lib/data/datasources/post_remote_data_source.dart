


import 'package:clean_architecture_with_bloc/core/network/api_service.dart';
import 'package:clean_architecture_with_bloc/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final _dio = ApiService.dio;

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await _dio.get('posts');
    return (response.data as List).map((json) => PostModel.fromJson(json)).toList();
  }
}