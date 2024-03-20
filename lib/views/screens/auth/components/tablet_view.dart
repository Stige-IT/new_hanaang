part of "../login.dart";

class TabletView extends ConsumerStatefulWidget {
  const TabletView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabletViewState();
}

class _TabletViewState extends ConsumerState<TabletView> {
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
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.onBackground,
                          ]),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/device.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 25,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            "assets/components/logo_hanaang.png",
                            height: 150,
                          ),
                          const SizedBox(height: 20),
                          AuthPageWidget(
                            formKey,
                            emailController: emailController,
                            passController: passController,
                            isObsecure: ref.watch(obsecureProvider),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}