part of "../login.dart";

class MobileView extends ConsumerStatefulWidget {
  const MobileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MobileViewState();
}

class _MobileViewState extends ConsumerState<MobileView> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passController;

  @override
  void initState() {
    emailController = TextEditingController();
    passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const AppBarSliver(),
        SliverList(
            delegate: SliverChildListDelegate([
          Card(
            elevation: 5,
            margin: const EdgeInsets.all(20.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      "Teh Tarik Hanaang",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    AuthPageWidget(
                      formKey,
                      emailController: emailController,
                      passController: passController,
                      isObsecure: ref.watch(obsecureProvider),
                    ),
                    SizedBox(height: 10.h),
                    Image.asset("assets/images/three_women.png"),
                  ],
                ),
              ),
            ),
          )
        ])),
      ],
    );
  }
}
