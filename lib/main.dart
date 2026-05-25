import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/bloc/app_bloc_observer.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'presentation/post_screen/bloc/product_bloc.dart';
import 'presentation/post_screen/bloc/product_event.dart';
import 'presentation/post_screen/product_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global observer: logs every event, state change, transition, and error
  Bloc.observer = const AppBlocObserver();

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture BLoC',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        // create + initial event in one place — screen's initState does nothing BLoC-related
        create: (_) => di.sl<ProductBloc>()..add(const LoadProductsEvent()),
        child: const ProductScreen(),
      ),
    );
  }
}
