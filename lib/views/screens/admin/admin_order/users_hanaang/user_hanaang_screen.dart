import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_providers.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_state.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/form_input.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:admin_hanaang/views/components/rounded_button.dart';
import 'package:admin_hanaang/views/components/snackbar.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/router/router_config.dart';
import '../../../../components/navigation_widget.dart';

final showSearchProvider = StateProvider<bool>((ref) => false);

class UserHanaangScreenAO extends ConsumerStatefulWidget {
  const UserHanaangScreenAO({super.key});

  @override
  ConsumerState createState() => _UserHanaangScreenAOState();
}

class _UserHanaangScreenAOState extends ConsumerState<UserHanaangScreenAO> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _searchCtrl;

  @override
  void initState() {
    _searchCtrl = TextEditingController();
    Future.microtask(() {
      ref.watch(roleNameUserProvider.notifier).state = "Semua";
      ref.watch(userNotifier.notifier).getData(makeLoading: true);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getData(String role) {
    ref.watch(roleNameUserProvider.notifier).state = role;
    ref.watch(userNotifier.notifier).getData();
  }

  @override
  Widget build(BuildContext context) {
    final isShowSearch = ref.watch(showSearchProvider);
    final roleNameSelected = ref.watch(roleNameUserProvider);
    final state = ref.watch(userNotifier);
    final dataUser = state.data;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        endDrawer: const EndrawerWidget(),
        appBar: AppbarAdmin(scaffoldKey: _scaffoldKey, title: "Pengguna"),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              nextPage(context, "${AppRoutes.admin}/user-hanaang/form"),
          icon: const Icon(Icons.add),
          label: const Text("Tambah pengguna"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () {
              ref.watch(userNotifier.notifier).refresh(makeLoading: true);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                ///[*Radio button type user & search field]
                _buildNavbar(roleNameSelected, state, context, isShowSearch),

                ///[*build data table]
                Expanded(
                  child: Card(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: 1,
                        itemBuilder: (_, i) {
                          return DataTable(
                              columnSpacing: 0,
                              border: TableBorder(
                                  horizontalInside: const BorderSide(
                                    width: 1,
                                    color: Colors.black38,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              showBottomBorder: true,
                              showCheckboxColumn: false,
                              headingTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              columns: const [
                                DataColumn(
                                    label: Expanded(
                                        child: Center(child: Text('No')))),
                                DataColumn(
                                    label: Expanded(
                                        child: Center(child: Text('Photo')))),
                                DataColumn(
                                    label: Expanded(
                                        child: Center(
                                            child: Text('Nama Pengguna')))),
                                DataColumn(
                                    label: Expanded(
                                        child:
                                            Center(child: Text('No Telepon')))),
                                DataColumn(
                                    label: Expanded(
                                        child: Center(child: Text('Email')))),
                              ],
                              rows: List.generate((dataUser ?? []).length,
                                  (index) {
                                final user = dataUser?[index];
                                return DataRow(
                                  selected: index % 2 == 0,
                                  onSelectChanged: (value) {
                                    nextPage(context,
                                        "${AppRoutes.admin}/user-hanaang/detail",
                                        argument: user?.id);
                                  },
                                  cells: [
                                    DataCell(Center(
                                        child: Text((index + 1).toString()))),
                                    DataCell(user?.image == null
                                        ? Center(
                                            child: ProfileWithName(
                                                user?.name ?? " "))
                                        : Center(
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  "$BASE/${user?.image}"),
                                            ),
                                          )),
                                    DataCell(
                                        Center(child: Text(user?.name ?? ""))),
                                    DataCell(
                                        Center(child: Text(user?.email ?? ""))),
                                    DataCell(Center(
                                        child: Text(user?.phoneNumber ?? ""))),
                                  ],
                                );
                              }));
                        }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        if (state.page != state.totalPage) {
                          ref.read(userNotifier.notifier).getData(
                                initPage: state.page - 1,
                                makeLoading: true,
                              );
                        }
                      },
                    ),
                    Text('Page ${state.page} of ${state.totalPage ?? 0}'),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (state.page < state.totalPage!) {
                          ref.read(userNotifier.notifier).getData(
                                initPage: state.page + 1,
                                makeLoading: true,
                              );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildNavbar(String roleNameSelected, UserState state,
      BuildContext context, bool isShowSearch) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RoundedButton(
                  isSelected: roleNameSelected == "Semua",
                  title: "Semua",
                  onTap: () => getData("Semua"),
                ),
                RoundedButton(
                  isSelected: roleNameSelected == "Distributor",
                  title: "Distributor",
                  onTap: () => getData("Distributor"),
                ),
                RoundedButton(
                  isSelected: roleNameSelected == "Agen",
                  title: "Agen",
                  onTap: () => getData("Agen"),
                ),
                RoundedButton(
                  isSelected: roleNameSelected == "Keluarga",
                  title: "Keluarga",
                  onTap: () => getData("Keluarga"),
                ),
                RoundedButton(
                  isSelected: roleNameSelected == "Warga",
                  title: "Warga",
                  onTap: () => getData("Warga"),
                ),
                RoundedButton(
                  isSelected: roleNameSelected == "User",
                  title: "Pengguna Baru",
                  onTap: () => getData("User"),
                ),
              ],
            )),
        if (state.isLoading)
          LoadingInButton(
            color: Theme.of(context).colorScheme.primary,
          ),
        if (state.errorMessage != null)
          IconButton(
            onPressed: () {
              showSnackbar(
                context,
                state.errorMessage!,
                isWarning: true,
              );
            },
            icon: const Icon(Icons.warning_amber, color: Colors.red),
          ),
        const SizedBox(width: 20),
        Expanded(
          child: FieldInput(
            hintText: "Cari Pengguna ..",
            controller: _searchCtrl,
            textValidator: "Pengguna",
            keyboardType: TextInputType.text,
            obsecureText: false,
            isRounded: false,
            prefixIcons: const Icon(Icons.search),
            suffixIcon: isShowSearch
                ? IconButton(
                    onPressed: () {
                      ref
                          .watch(userNotifier.notifier)
                          .getData(makeLoading: true);
                      ref.invalidate(showSearchProvider);
                      _searchCtrl.clear();
                      FocusScope.of(context).unfocus();
                    },
                    icon: const Icon(Icons.close))
                : null,
            onTap: () {},
            onChanged: (value) {
              ref.read(userNotifier.notifier).searchData(value);
            },
          ),
        )
      ],
    );
  }
}
