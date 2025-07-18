import 'package:clean_architecture_with_bloc/domain/entities/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends PostEvent {}

class AddPostEvent extends PostEvent {
  final Post post;

  const AddPostEvent({required this.post});

  @override
  List<Object?> get props => [post];
}
