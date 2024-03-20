part of 'profile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileScreenAOState();
}

class _ProfileScreenAOState extends ConsumerState<ProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider);
    final user = state.data;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppbarAdmin(scaffoldKey: scaffoldKey, title: "Profil Admin"),
      endDrawer: const EndrawerWidget(),
      body: Builder(builder: (_) {
        if (user == null) {
          return ErrorButtonWidget(
            errorMsg: "Data tidak ditemukan, coba lagi",
            onTap: () {
              ref.read(userNotifierProvider.notifier).getProfile();
            },
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              if (user.image == null)
                ProfileWithName(user.name ?? "--", radius: 70)
              else
                CircleAvatarNetwork("$BASE/${user.image}", radius: 140),
              Text(
                user.name!,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text("Email",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    user.email!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text("No.Telepon",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    user.phoneNumber!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => dialogLogout(context, ref),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "keluar",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
