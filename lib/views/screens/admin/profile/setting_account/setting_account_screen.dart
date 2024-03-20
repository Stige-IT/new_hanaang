part of "../profile.dart";

class SettingAccountScreen extends ConsumerStatefulWidget {
  const SettingAccountScreen({super.key});

  @override
  ConsumerState createState() => _SettingAccountScreenAOState();
}

class _SettingAccountScreenAOState
    extends ConsumerState<SettingAccountScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final List<Widget> settingsScreen = [
    const SettingFormDataUser(),
    const SettingFormDataAddress(),
    const SettingFormDataPassword(),
  ];

  @override
  void dispose() {
    ref.invalidate(indexProvider);
    ref.invalidate(idProvinceProvider);
    ref.invalidate(provinceNotifier);
    ref.invalidate(idRegencyProvider);
    ref.invalidate(regencyNotifier);
    ref.invalidate(idDistrictProvider);
    ref.invalidate(districtNotifier);
    ref.invalidate(idVillageProvider);
    ref.invalidate(villagetNotifier);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(indexProvider);
    return Scaffold(
        key: _key,
        endDrawer: const EndrawerWidget(),
        appBar: AppbarAdmin(scaffoldKey: _key, title: "Setting Profil"),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    selected: index == 0,
                    leading: const Icon(Icons.person),
                    title: const Text("Data Profil"),
                    onTap: () => ref.watch(indexProvider.notifier).state = 0,
                  ),
                  ListTile(
                    selected: index == 1,
                    leading: const Icon(Icons.location_city),
                    title: const Text("Alamat"),
                    onTap: () => ref.watch(indexProvider.notifier).state = 1,
                  ),
                  ListTile(
                    selected: index == 2,
                    leading: const Icon(Icons.security),
                    title: const Text("Ganti Password"),
                    onTap: () => ref.watch(indexProvider.notifier).state = 2,
                  ),
                ],
              ),
            )),
            Expanded(
                flex: 4,
                child: ScrollConfiguration(
                  behavior: const MaterialScrollBehavior()
                      .copyWith(overscroll: false),
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(15.0),
                      itemCount: 1,
                      itemBuilder: (_, i) => settingsScreen[index]),
                )),
            const Spacer(),
          ],
        ));
  }
}

final indexProvider = StateProvider<int>((ref) => 0);
