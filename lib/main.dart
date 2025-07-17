import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/datasources/post_remote_data_source.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/usecases/get_posts_usecase.dart';

import 'presentation/post_screen/post_screen.dart';
import 'presentation/post_screen/post_screen_bloc.dart';
import 'presentation/post_screen/post_screen_event.dart';

void main() {
  // Setup dependencies
  final postRemoteDataSource = PostRemoteDataSourceImpl();
  final postRepository = PostRepositoryImpl(postRemoteDataSource);
  final getPostsUseCase = GetPostsUseCase(postRepository);

  runApp(MyApp(getPostsUseCase: getPostsUseCase));
}

class MyApp extends StatelessWidget {
  final GetPostsUseCase getPostsUseCase;
  const MyApp({super.key, required this.getPostsUseCase});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture BLoC',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => PostBloc(getPostsUseCase)..add(LoadPostsEvent()),
        child: const PostScreen(),
      ),
    );
  }
}
