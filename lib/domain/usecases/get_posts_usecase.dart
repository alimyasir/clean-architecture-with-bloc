

import 'package:clean_architecture_with_bloc/domain/entities/post.dart';
import 'package:clean_architecture_with_bloc/domain/repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Future<List<Post>> call() async {
    return await repository.getPosts();
  }
}