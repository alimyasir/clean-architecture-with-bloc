import 'package:get_it/get_it.dart';

import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'presentation/post_screen/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Factory: fresh BLoC instance per BlocProvider — no stale state across navigations
  sl.registerFactory(() => ProductBloc(sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetProductUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(),
  );
}
