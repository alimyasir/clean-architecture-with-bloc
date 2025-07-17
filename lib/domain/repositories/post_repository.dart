import 'package:clean_architecture_with_bloc/domain/entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
}