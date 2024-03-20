part of "../suplayer.dart";

class DetailSuplayerScreenAdmin extends ConsumerStatefulWidget {
  final String suplayerId;

  const DetailSuplayerScreenAdmin(this.suplayerId, {super.key});

  @override
  ConsumerState createState() => _DetailSuplayerScreenState();
}

class _DetailSuplayerScreenState
    extends ConsumerState<DetailSuplayerScreenAdmin> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(
      () => ref
          .read(suplayerByIdNotifier.notifier)
          .getSuplayer(widget.suplayerId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(suplayerByIdNotifier);
    final suplayer = state.data;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppbarAdmin(scaffoldKey: _scaffoldKey, title: "Detail Suplayer"),
      endDrawer: const EndrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () async {
          Future.delayed(const Duration(seconds: 1), () {
            ref
                .read(suplayerByIdNotifier.notifier)
                .getSuplayer(widget.suplayerId);
          });
        },
        child: Builder(builder: (_) {
          if (state.isLoading) {
            return Center(
              child:
                  LoadingInButton(color: Theme.of(context).colorScheme.primary),
            );
          } else if (state.error != null) {
            return ErrorButtonWidget(
                errorMsg: state.error!,
                onTap: () {
                  ref
                      .read(suplayerByIdNotifier.notifier)
                      .getSuplayer(widget.suplayerId);
                });
          }
          return ListView(
            padding: const EdgeInsets.all(25.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (suplayer?.image != null)
                    CircleAvatarNetwork("$BASE/${suplayer?.image}", radius: 140)
                  else
                    ProfileWithName(suplayer?.name ?? "--", radius: 70),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        suplayer?.name ?? "-",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(suplayer?.phoneNumber ?? "-"),
                    ),
                  ),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: () => nextPage(
                          context,
                          "${AppRoutes.admin}/suplayer/form",
                          argument: suplayer,
                        ),
                        child: const Text("Edit"),
                      ),
                      const SizedBox(width: 20),
                      FilledButton(
                        onPressed: () => dialogDelete(
                          context,
                          ref,
                          suplayerId: suplayer!.id!,
                          isDetailPage: true,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Hapus"),
                      ),
                    ],
                  ),
                ],
              ),
              Wrap(
                children: (suplayer?.rawMaterial ?? []).map((material) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: InkWell(
                      onTap: () {},
                      child: Chip(
                        label: Text(material.name ?? "-",
                            style: const TextStyle(color: Colors.white)),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Divider(thickness: 2),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ContainerAddress(
                            label: "Provinsi",
                            value: suplayer?.address?.province?.name ?? "-",
                          ),
                          ContainerAddress(
                            label: "Kabupaten",
                            value: suplayer?.address?.regency?.name ?? "-",
                          ),
                          ContainerAddress(
                            label: "Kecamatan",
                            value: suplayer?.address?.district?.name ?? "-",
                          ),
                          ContainerAddress(
                            label: "Kelurahan",
                            value: suplayer?.address?.village?.name ?? "-",
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                        child: ContainerAddress(
                      label: "Detail Alamat",
                      value: suplayer?.address?.detail ?? "-",
                      isMultiLine: true,
                    ))
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
