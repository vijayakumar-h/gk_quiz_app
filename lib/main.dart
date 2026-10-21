import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gk_quiz_app/blocs/category/category_bloc.dart';
import 'package:gk_quiz_app/screens/home_screen.dart';
import 'package:gk_quiz_app/utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GKQuizApp());
}

class GKQuizApp extends StatelessWidget {
  const GKQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc()..add(const LoadCategoriesEvent()),
      child: MaterialApp(
        title: 'GK Quiz App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
