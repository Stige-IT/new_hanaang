part of "splash.dart";

final percentProvider = StateProvider.autoDispose<double>((ref) => 0);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    Future.microtask(() => ref.read(roleNotifier.notifier).getRole());
    Timer(const Duration(seconds: 2), () async {
      final storage = ref.watch(storageProvider);
      final session = await storage.read("role_name");
      if (session != null) {
        if (!mounted) return;
        final page = navigationFirstRole(session);
        nextPageRemove(context, page);
      } else {
        if (!mounted) return;
        nextPageRemove(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints) {
        if (isTabletType()) {
          return const TabletView();
        } else {
          return const MobileView();
        }
      }),
    );
  }
}
