import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/employee/provider/employee_provider.dart';
import 'package:admin_hanaang/features/position/provider/order_provider.dart';
import 'package:admin_hanaang/models/position.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../../models/employee.dart';
import '../../../../utils/constant/base_url.dart';
import '../../../components/circle_avatar_network.dart';

///[STATE ISHOW SEARCH]
final isShowsearchProvider = StateProvider.autoDispose<bool>((ref) => false);

///[STATE SEARCH DATA]
final searchProvider =
    StateNotifierProvider<SearchNotifier, List<Employee>>((ref) {
  return SearchNotifier();
});

class SearchNotifier extends StateNotifier<List<Employee>> {
  SearchNotifier() : super([]);

  searchData(List<Employee> data, {required String query}) {
    List<Employee> temp = [];
    for (Employee item in data) {
      if (item.name!.toLowerCase().contains(query.toLowerCase())) {
        temp.add(item);
      }
    }
    state = temp;
  }
}

///["STATE POP MENU ITEM SELECTED"]
final popMenuItemNotifier = StateProvider.autoDispose<String>((ref) => "");

class EmployeeListScreen extends ConsumerStatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmployeeListScreenState();
}

class _EmployeeListScreenState extends ConsumerState<EmployeeListScreen> {
  late TextEditingController _searchCtrl;

  @override
  void initState() {
    Future.microtask(() {
      ref.watch(employeesNotifier.notifier).getEmployee();
      ref.watch(positionNotifier.notifier).getPostions();
    });
    _searchCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isShowSearch = ref.watch(isShowsearchProvider);
    final state = ref.watch(employeesNotifier);
    final employess = state.data;
    final positions = ref.watch(positionNotifier).data;
    final dataSearch = ref.watch(searchProvider);
    final selectedPopMenu = ref.watch(popMenuItemNotifier);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: isShowSearch
            ? TextField(
                autofocus: true,
                controller: _searchCtrl,
                cursorColor: Colors.black,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Silahkan Cari ",
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      ref
                          .watch(searchProvider.notifier)
                          .searchData(employess ?? [], query: _searchCtrl.text);
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
                onChanged: (value) {
                  ref
                      .watch(searchProvider.notifier)
                      .searchData(employess ?? [], query: value);
                },
              )
            : const Text("Daftar Karyawan"),
        actions: [
          IconButton(
              onPressed: () {
                _searchCtrl.clear();
                ref.watch(isShowsearchProvider.notifier).state = !isShowSearch;
              },
              icon: isShowSearch
                  ? const Icon(Icons.close)
                  : const Icon(Icons.search)),
          PopupMenuButton<String?>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (_) {
              return [...?positions, Position(id: '', name: "Semua Jabatan")]
                  .map((position) => PopupMenuItem<String?>(
                        value: position.id,
                        child: Text(
                          position.name ?? '-',
                          style: TextStyle(
                            fontWeight: selectedPopMenu == position.id
                                ? FontWeight.bold
                                : null,
                          ),
                        ),
                      ))
                  .toList();
            },
            onSelected: (value) {
              ref
                  .watch(employeesNotifier.notifier)
                  .getEmployee(positionId: value);
              ref.watch(popMenuItemNotifier.notifier).state = value!;
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.read(employeesNotifier.notifier).getEmployee();
            ref.invalidate(popMenuItemNotifier);
          });
        },
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : employess == null
                ? const Center(child: Text("Data tidak ditemukan"))
                : Builder(builder: (_) {
                    if (employess.isEmpty && !isShowSearch) {
                      return const Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_alt_outlined, size: 50),
                          Text("Tidak ada karyawan"),
                        ],
                      ));
                    }
                    return ListView.separated(
                        padding: const EdgeInsets.all(10.0),
                        itemBuilder: (_, i) {
                          Employee employee =
                              isShowSearch ? dataSearch[i] : employess[i];
                          return _cardEmployee(employee);
                        },
                        separatorBuilder: (_, i) {
                          return const SizedBox(height: 3);
                        },
                        itemCount: isShowSearch
                            ? dataSearch.length
                            : employess.length);
                  }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => nextPage(context, "${AppRoutes.sa}/employee/form"),
        icon: const Icon(Icons.add),
        label: const Text("Tambah Karyawan"),
      ),
    );
  }

  Card _cardEmployee(Employee employee) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () => nextPage(
          context,
          "${AppRoutes.sa}/employee/detail",
          argument: employee,
        ),
        leading: employee.image != null
            ? CircleAvatarNetwork("$BASE/${employee.image}")
            : CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.black,
                child: Text(employee.name![0]),
              ),
        title: Text(
          employee.name ?? "-",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(employee.position?.name ?? "Jabatan: -"),
        trailing: PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                nextPage(context, "${AppRoutes.sa}/employee/form",
                    argument: employee);
                break;
              case 'delete':
                PanaraConfirmDialog.show(
                  context,
                  message: "Yakin hapus Karyawan?",
                  confirmButtonText: "Hapus",
                  cancelButtonText: "Kembali",
                  onTapConfirm: () async {
                    final result = await ref
                        .watch(employeesNotifier.notifier)
                        .deleteEmployee(employee: employee);
                    if (!mounted) return;
                    if (result) {
                      Navigator.of(context).pop();
                      showSnackbar(context, "Berhasil dihapus");
                    } else {
                      showSnackbar(context, "Gagal hapus karyawan",
                          isWarning: true);
                    }
                  },
                  onTapCancel: () => Navigator.of(context).pop(),
                  panaraDialogType: PanaraDialogType.error,
                );
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          itemBuilder: (_) {
            return [
              const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    visualDensity: VisualDensity(vertical: -3, horizontal: -3),
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.edit),
                    title: Text("Edit"),
                  )),
              const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    visualDensity: VisualDensity(vertical: -3, horizontal: -3),
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: Text("Hapus"),
                  )),
            ];
          },
        ),
      ),
    );
  }
}
