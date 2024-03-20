import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_providers.dart';
import 'package:admin_hanaang/models/users_hanaang.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:admin_hanaang/views/components/container_address.dart';
import 'package:admin_hanaang/views/components/error_button_widget.dart';
import 'package:admin_hanaang/views/components/label.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/empty_widget.dart';

class DetailUsersHanaangScreen extends ConsumerStatefulWidget {
  final UsersHanaang user;

  const DetailUsersHanaangScreen({super.key, required this.user});

  @override
  ConsumerState createState() => _DetailUsersHanaangScreenState();
}

class _DetailUsersHanaangScreenState
    extends ConsumerState<DetailUsersHanaangScreen> {
  void _getData() {
    ref.watch(userDetailNotifier.notifier).getUsersHanaang(widget.user.id!);
  }

  @override
  void initState() {
    Future.microtask(() => _getData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userDetailNotifier);
    final user = state.data;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          nextPage(context, "${AppRoutes.sa}/order/form",
              argument: widget.user);
        },
        label: const Text("Pesanan Baru"),
        icon: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          const AppBarSliver(title: "Profil Pengguna"),
          SliverList(
              delegate: SliverChildListDelegate([
            Builder(builder: (_) {
              if (state.isLoading) {
                return Center(
                  child: LoadingInButton(color: Theme.of(context).colorScheme.primary),
                );
              } else if (state.error != null) {
                return ErrorButtonWidget(
                    errorMsg: state.error!, onTap: () => _getData);
              } else if (user == null) {
                return const Center(child: EmptyWidget());
              } else {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              if (user.image == null)
                                ProfileWithName(user.name ?? ".", radius: 30)
                              else
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage("$BASE/${user.image}"),
                                ),
                              if (user.userRole != null)
                                SizedBox(
                                  height: 30,
                                  child: Label(
                                    status: "partial",
                                    title: user.userRole ?? "",
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? '-',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(widget.user.email ?? "Email: -"),
                              Text(widget.user.phoneNumber ?? "No.Telepon: -")
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${user.totalOrder ?? 0}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text("Pesanan"),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${user.totalRetur ?? 0}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const Text("Retur"),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${user.totalHutang?.length ?? 0}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text("Hutang"),
                            ],
                          ),
                          if (user.totalWarung != null)
                            InkWell(
                              onTap: () => nextPage(
                                  context, "${AppRoutes.sa}/markets",
                                  argument: user.id),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("${user.totalWarung ?? 0}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const Text("Warung"),
                                ],
                              ),
                            ),
                          if (user.totalAgen != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${user.totalAgen ?? 0}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const Text("Agen"),
                              ],
                            )
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Alamat",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const Divider(thickness: 2),
                      ContainerAddress(
                        label: "Provinsi",
                        value: user.address?.province,
                      ),
                      ContainerAddress(
                        label: "Kabupaten",
                        value: user.address?.regency,
                      ),
                      ContainerAddress(
                        label: "Kecamatan",
                        value: user.address?.district,
                      ),
                      ContainerAddress(
                        label: "Kelurahan",
                        value: user.address?.village,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Detail Alamat",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const Divider(thickness: 2),
                      ContainerAddress(
                        isMultiLine: true,
                        value: user.address?.detail,
                      )
                    ],
                  ),
                );
              }
            })
          ]))
        ],
      ),
    );
  }
}
