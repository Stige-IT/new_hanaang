part of "../material.dart";

class MaterialScreenAdmin extends ConsumerStatefulWidget {
  const MaterialScreenAdmin({super.key});

  @override
  ConsumerState createState() => _MaterialScreenAdminState();
}

class _MaterialScreenAdminState extends ConsumerState<MaterialScreenAdmin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() => ref.read(materialsNotifier.notifier).getMaterials());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppbarAdmin(isMain: true, scaffoldKey: _scaffoldKey, title: "Bahan Baku"),
      endDrawer: const EndrawerWidget(),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderMaterial(),
            DataTableMaterial(),
          ],
        ),
      ),
    );
  }
}
