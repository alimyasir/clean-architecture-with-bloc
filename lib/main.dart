import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart' as di;
import 'presentation/post_screen/post_screen.dart';
import 'presentation/post_screen/post_screen_bloc.dart';
import 'presentation/post_screen/post_screen_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize all dependencies

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture BLoC',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => di.sl<PostBloc>()..add(LoadPostsEvent()),
        child: const PostScreen(),
      ),
    );
  }
}
