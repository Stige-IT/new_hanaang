import 'dart:developer';

import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/admin_hanaang/provider/admin_hanaang_provider.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final typeAdminNotifier =
    StateProvider.autoDispose<List<dynamic>>((ref) => ["Semua Admin", "all"]);
final isShowSearchProvider = StateProvider.autoDispose<bool>((ref) => false);

class AdminHanaangScreen extends ConsumerStatefulWidget {
  const AdminHanaangScreen({super.key});

  @override
  ConsumerState createState() => _AdminHanaangScreenState();
}

class _AdminHanaangScreenState extends ConsumerState<AdminHanaangScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  @override
  void initState() {
    Future.microtask(
      () => ref
          .read(adminHanaangNotifier.notifier)
          .getAdminHanaang(makeLoading: true),
    );

    _searchController = TextEditingController();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (ref.watch(adminHanaangNotifier).page !=
            ref.watch(adminHanaangNotifier).lastPage) {
          log("GET MORE DATA");
          ref
              .read(adminHanaangNotifier.notifier)
              .loadDataMore(ref.watch(typeAdminNotifier)[1]);
        }
      }
    });
    super.initState();
  }

  // data[0] => title to set title appbar
  // data[1] => id to send parameter api
  List<List<String>> data = [
    ["Semua Admin", "all"],
    ["Admin Order", '6ddd7c18-90e6-46c7-a105-489991970193'],
    ["Admin Gudang 1", 'b57e9747-f8ac-4d26-a39e-406f38c06eb0'],
    ["Admin Gudang 2", 'be96d685-2322-11ee-8a79-5ea00b5791d2'],
    ["Admin Gudang 3", 'c7df2fad-2322-11ee-8a79-5ea00b5791d2'],
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminHanaangNotifier);
    final dataAdmin = state.data;
    final typeAdmin = ref.watch(typeAdminNotifier);
    final isShowSearch = ref.watch(isShowSearchProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: isShowSearch
            ? TextField(
                controller: _searchController,
                cursorColor: Colors.white,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  ref.read(adminHanaangNotifier.notifier).searchByQuery(value);
                },
              )
            : Text(typeAdmin[0], style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            onPressed: () {
              if (isShowSearch) {
                _searchController.clear();
                ref.read(adminHanaangNotifier.notifier).refresh();
                ref.invalidate(typeAdminNotifier);
              }
              ref.read(isShowSearchProvider.notifier).state = !isShowSearch;
            },
            icon: isShowSearch
                ? const Icon(Icons.close)
                : const Icon(Icons.search),
          ),
          PopupMenuButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (_) {
              return data
                  .map((value) => PopupMenuItem<List<String>>(
                        value: value,
                        child: Text(value[0],
                            style: TextStyle(
                                fontWeight: typeAdmin[0] == value[0]
                                    ? FontWeight.bold
                                    : null)),
                      ))
                  .toList();
            },
            onSelected: (value) {
              ref
                  .watch(adminHanaangNotifier.notifier)
                  .getAdminHanaang(roleId: value[1], makeLoading: true);

              ref.watch(typeAdminNotifier.notifier).state = value;
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.invalidate(typeAdminNotifier);
            ref.read(adminHanaangNotifier.notifier).refresh();
          });
        },
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : dataAdmin == null
                ? const Center(
                    child: Text("Tidak ada Data"),
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 100.0),
                    itemCount: ref.watch(adminHanaangNotifier).isLoadingMore
                        ? dataAdmin.length + 1
                        : dataAdmin.length,
                    itemBuilder: (_, i) {
                      if (ref.watch(adminHanaangNotifier).isLoadingMore &&
                          i == dataAdmin.length) {
                        return const Center(
                          child: SizedBox(
                              height: 35,
                              width: 35,
                              child: CircularProgressIndicator()),
                        );
                      }
                      final admin = dataAdmin[i];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: admin.suspend == '0'
                                ? Colors.transparent
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        color: Theme.of(context).colorScheme.surface,
                        child: ListTile(
                          onTap: () => nextPage(
                            context,
                            "${AppRoutes.sa}/admin-hanaang/detail",
                            argument: admin.id,
                          ),
                          leading: admin.image == null
                              ? CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  child: Text(
                                    admin.name![0],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              : CircleAvatarNetwork("$BASE/${admin.image!}"),
                          title: Text(admin.name!),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(admin.email ?? 'No.Telp: -'),
                              Text(admin.phoneNummber ?? 'No.Telp: -'),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, i) => const SizedBox(height: 7),
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            nextPage(context, "${AppRoutes.sa}/admin-hanaang/create"),
        extendedTextStyle: const TextStyle(fontSize: 14),
        icon: const Icon(Icons.add),
        label: const Text("Tambah Admin"),
      ),
    );
  }
}
