import 'package:admin_hanaang/features/users_hanaang/provider/users_hanaang_providers.dart';
import 'package:admin_hanaang/utils/constant/base_url.dart';
import 'package:admin_hanaang/views/components/appbar_admin.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:admin_hanaang/views/screens/admin/components/endrawer/endrawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/container_label.dart';
import '../../components/tile_address.dart';

class DetailUserScreenAO extends ConsumerStatefulWidget {
  final String userId;

  const DetailUserScreenAO(this.userId, {super.key});

  @override
  ConsumerState createState() => _DetailUserScreenAOState();
}

class _DetailUserScreenAOState extends ConsumerState<DetailUserScreenAO> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.microtask(() =>
        ref.watch(userDetailNotifier.notifier).getUsersHanaang(widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userDetailNotifier);
    final user = state.data;
    // ScreenUtil.init(
    //   context,
    //   designSize: const Size(600, 1024),
    //   minTextAdapt: true,
    // );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppbarAdmin(scaffoldKey: _scaffoldKey, title: "Detail Pengguna"),
      endDrawer: const EndrawerWidget(),
      body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () {});
          },
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.error != null && user == null
                  ? Center(
                      child: Text(state.error!),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  if (user?.image != null)
                                    CircleAvatarNetwork("$BASE/${user!.image}", radius: 140,)
                                  else
                                    ProfileWithName(user?.name ?? "  ",
                                        radius: 70),
                                  SizedBox(
                                      width: 100,
                                      child: ContainerLabel(
                                          title: user?.userRole ?? "")),
                                ],
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?.name ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      user?.email ?? "Email: -",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      user?.phoneNumber ?? "No.Telp: -",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: GridView.count(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15,
                                    childAspectRatio: 4 / 1.2,
                                    children: [
                                      ContainerLabel(
                                          title:
                                              "${user?.totalOrder ?? 0} Pesanan"),
                                      ContainerLabel(
                                          title:
                                              "${user?.totalRetur ?? 0} Pesanan"),
                                      ContainerLabel(
                                          title:
                                              "${user?.totalHutang?.length ?? 0} Hutang"),
                                      if (user?.totalWarung != null)
                                        ContainerLabel(
                                            title:
                                                "${user?.totalWarung ?? 0} Warung"),
                                      if (user?.totalAgen != null)
                                        ContainerLabel(
                                            title:
                                                "${user?.totalAgen ?? 0} Agen"),
                                    ],
                                  )),
                            ],
                          ),
                          const Divider(thickness: 3),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    TileAddress(
                                      title: "Provinsi",
                                      value: user?.address?.province ?? "-",
                                    ),
                                    TileAddress(
                                      title: "Kabupaten/Kota",
                                      value: user?.address?.regency ?? "-",
                                    ),
                                    TileAddress(
                                      title: "Kecamatan",
                                      value: user?.address?.district ?? "-",
                                    ),
                                    TileAddress(
                                      title: "Kelurahan",
                                      value: user?.address?.village ?? "-",
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                  flex: 2,
                                  child: ListTile(
                                    title: const Text("Alamat Detail",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                    subtitle: Text(user?.address?.detail ?? "-",
                                        style: const TextStyle(fontSize: 20)),
                                  ))
                            ],
                          )
                        ],
                      ),
                    )),
    );
  }
}
