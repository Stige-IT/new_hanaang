import 'package:admin_hanaang/features/admin_hanaang/provider/admin_hanaang_provider.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:admin_hanaang/views/components/circle_avatar_network.dart';
import 'package:admin_hanaang/views/components/container_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constant/base_url.dart';
import '../../../components/label.dart';
import '../../../components/loading_in_button.dart';
import '../../../components/profile_with_name.dart';

class DetailAdminHanaangScreen extends ConsumerStatefulWidget {
  final String adminHanaangId;
  const DetailAdminHanaangScreen(this.adminHanaangId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailAdminHanaangScreenState();
}

class _DetailAdminHanaangScreenState
    extends ConsumerState<DetailAdminHanaangScreen> {
  @override
  void initState() {
    Future.microtask(() => ref
        .read(detailAdminHanaangNotifier.notifier)
        .getDetailData(widget.adminHanaangId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailAdminHanaangNotifier);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const AppBarSliver(title: "Detail Admin"),
          SliverList(
            delegate: SliverChildListDelegate([
              if (state.isLoading)
                Center(child: LoadingInButton(color: Theme.of(context).colorScheme.primary))
              else
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              if (state.data?.image == null)
                                ProfileWithName(state.data?.name, radius: 30)
                              else
                                CircleAvatarNetwork(
                                    "$BASE/${state.data?.image}"),
                              if (state.data?.userRole != null)
                                SizedBox(
                                  height: 30,
                                  child: Label(
                                    status: "partial",
                                    title: state.data?.userRole,
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.data?.name ?? '-',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(state.data?.email ?? "Email: -"),
                              Text(state.data?.phoneNummber ?? "No.Telepon: -")
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
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
                        value: state.data?.address?.province?.name,
                      ),
                      ContainerAddress(
                        label: "Kabupaten",
                        value: state.data?.address?.regency?.name,
                      ),
                      ContainerAddress(
                        label: "Kecamatan",
                        value: state.data?.address?.district?.name,
                      ),
                      ContainerAddress(
                        label: "Kelurahan",
                        value: state.data?.address?.village?.name,
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
                        value: state.data?.address?.detail,
                      )
                    ],
                  ),
                )
            ]),
          )
        ],
      ),
    );
  }
}
