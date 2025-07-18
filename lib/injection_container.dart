import 'package:get_it/get_it.dart';

import 'data/datasources/post_remote_data_source.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'presentation/post_screen/post_screen_bloc.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  // BLoC
  // sl.registerFactory(() => PostBloc(sl()));
  sl.registerLazySingleton(() => PostBloc(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<PostRepository>(
        () => PostRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(
        () => PostRemoteDataSourceImpl(),
  );
}
