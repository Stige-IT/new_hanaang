part of "../resep.dart";

class ResepScreenAdmin extends ConsumerStatefulWidget {
  const ResepScreenAdmin({super.key});

  @override
  ConsumerState createState() => _ResepScreenAdminState();
}

class _ResepScreenAdminState extends ConsumerState<ResepScreenAdmin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar:
          AppbarAdmin(isMain: true, scaffoldKey: _scaffoldKey, title: "Resep"),
      endDrawer: const EndrawerWidget(),
      body: const Row(
        children: [
          ListViewResep(),
          VerticalDivider(thickness: 2),
          DetailResep(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Tambah Resep"),
      ),
    );
  }
}
