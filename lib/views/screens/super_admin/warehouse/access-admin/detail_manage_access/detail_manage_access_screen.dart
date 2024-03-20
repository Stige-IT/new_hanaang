part of "../access_admin.dart";

class DetailManageAccessScreen extends ConsumerStatefulWidget {
  final String manageAccessId;
  final String name;

  const DetailManageAccessScreen(this.manageAccessId,
      {super.key, required this.name});

  @override
  ConsumerState createState() => _DetailManageAccessScreenState();
}

class _DetailManageAccessScreenState
    extends ConsumerState<DetailManageAccessScreen> {
  @override
  void initState() {
    Future.microtask(
      () => ref
          .read(manageAccessNotifier.notifier)
          .getData(typeId: widget.manageAccessId, makeLoading: true),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(manageAccessNotifier);
    final data = state.data;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.name),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1), () {
                ref
                    .read(manageAccessNotifier.notifier)
                    .getData(typeId: widget.manageAccessId);
              });
            },
            child: Builder(
              builder: (_) {
                if (state.isLoading) {
                  return Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary));
                } else if (state.error != null) {
                  return ErrorButtonWidget(
                    errorMsg: state.error!,
                    onTap: () {
                      ref
                          .read(manageAccessNotifier.notifier)
                          .getData(typeId: widget.manageAccessId);
                    },
                  );
                } else {
                  return ListView.separated(
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (_, i) {
                      ManageAccess access = data![i];
                      return Card(
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ExpansionTile(
                          title: Text(access.categoryAccess ?? "-"),
                          children: [
                            ListTile(
                              leading: access.create == "1"
                                  ? const Icon(Icons.check_circle)
                                  : const Icon(Icons.circle_outlined),
                              title: const Text("Membuat data baru"),
                              onTap: () {
                                ref
                                    .read(updateManageAccessNotifier.notifier)
                                    .updateData(
                                      widget.manageAccessId,
                                      access.id!,
                                      create: access.create == "1" ? "0" : "1",
                                      read: access.read!,
                                      update: access.update!,
                                      delete: access.delete!,
                                    );
                              },
                            ),
                            ListTile(
                              leading: access.read == "1"
                                  ? const Icon(Icons.check_circle)
                                  : const Icon(Icons.circle_outlined),
                              title: const Text("Melihat data"),
                              onTap: () {
                                ref
                                    .read(updateManageAccessNotifier.notifier)
                                    .updateData(
                                      widget.manageAccessId,
                                      access.id!,
                                      create: access.create!,
                                      read: access.read == "1" ? "0" : "1",
                                      update: access.update!,
                                      delete: access.delete!,
                                    );
                              },
                            ),
                            ListTile(
                              leading: access.update == "1"
                                  ? const Icon(Icons.check_circle)
                                  : const Icon(Icons.circle_outlined),
                              title: const Text("Merubah data"),
                              onTap: () {
                                ref
                                    .read(updateManageAccessNotifier.notifier)
                                    .updateData(
                                      widget.manageAccessId,
                                      access.id!,
                                      create: access.create!,
                                      read: access.read!,
                                      update: access.update == "1" ? "0" : "1",
                                      delete: access.delete!,
                                    );
                              },
                            ),
                            ListTile(
                              leading: access.delete == "1"
                                  ? const Icon(Icons.check_circle)
                                  : const Icon(Icons.circle_outlined),
                              title: const Text("Menghapus data"),
                              onTap: () {
                                ref
                                    .read(updateManageAccessNotifier.notifier)
                                    .updateData(
                                      widget.manageAccessId,
                                      access.id!,
                                      create: access.create!,
                                      read: access.read!,
                                      update: access.update!,
                                      delete: access.delete == "1" ? "0" : "1",
                                    );
                              },
                            ),
                            // const SizedBox(height: 10),
                            // FilledButton(onPressed: (){}, child: const Text("Simpan")),
                            // const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, i) => const SizedBox(height: 5),
                    itemCount: (data ?? []).length,
                  );
                }
              },
            ),
          ),
          if(ref.watch(updateManageAccessNotifier).isLoading)
            const DialogLoading()
        ],
      ),
    );
  }
}
