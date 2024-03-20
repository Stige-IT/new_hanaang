part of '../suplayer.dart';

class SuplayerScreenAdmin extends ConsumerStatefulWidget {
  const SuplayerScreenAdmin({super.key});

  @override
  ConsumerState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<SuplayerScreenAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() {
      ref.read(suplayerNotifier.notifier).getSuplayer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: const EndrawerWidget(),
        appBar: AppbarAdmin(
          scaffoldKey: _scaffoldKey,
          isMain: true,
          title: "Suplayer",
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () {
              ref.read(suplayerNotifier.notifier).getSuplayer();
            });
          },
          child: const Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeaderSuplayer(),
                DataTableSuplayer(),
              ],
            ),
          ),
        ));
  }
}
