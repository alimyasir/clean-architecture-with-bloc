import 'package:bloc/bloc.dart';
import 'package:clean_architecture_with_bloc/presentation/post_screen/bloc/post_screen_event.dart';
import 'package:clean_architecture_with_bloc/presentation/post_screen/bloc/post_screen_state.dart';
import '../../../../domain/usecases/get_posts_usecase.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase getPostsUseCase;

  PostBloc(this.getPostsUseCase) : super(PostInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
  }

  Future<void> _onLoadPosts(
      LoadPostsEvent event,
      Emitter<PostState> emit,
      ) async {
    emit(PostLoading());
    try {
      final posts = await getPostsUseCase();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
