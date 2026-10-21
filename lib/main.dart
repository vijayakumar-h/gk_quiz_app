import 'package:gk_quiz_app/utils/common_exports.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GKQuizApp());
}

class GKQuizApp extends StatelessWidget {
  const GKQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GK Quiz App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
