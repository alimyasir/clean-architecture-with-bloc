

import 'package:clean_architecture_with_bloc/data/datasources/post_remote_data_source.dart';
import 'package:clean_architecture_with_bloc/domain/entities/post.dart';
import 'package:clean_architecture_with_bloc/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts() async {
    return await remoteDataSource.getPosts();
  }
}