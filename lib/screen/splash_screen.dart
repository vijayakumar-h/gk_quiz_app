import 'package:chat_app/utils/common_exports.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Image.asset('assets/images/chat.png'),
      ),
    );
  }
}
