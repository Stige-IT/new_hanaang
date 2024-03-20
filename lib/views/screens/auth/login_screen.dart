part of 'login.dart';

///[For obsecure]
final obsecureProvider = StateProvider<bool>((ref) => true);

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (isTabletType()) {
            return const TabletView();
          }
          return const MobileView();
        }),
      ),
    );
  }
}
