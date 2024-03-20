import 'package:admin_hanaang/features/market/provider/market_provider.dart';
import 'package:admin_hanaang/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constant/base_url.dart';
import '../../../components/container_address.dart';
import '../../../components/profile_with_name.dart';

class DetailMarketScreen extends ConsumerStatefulWidget {
  final String marketId;
  const DetailMarketScreen(this.marketId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailMarketScreenState();
}

class _DetailMarketScreenState extends ConsumerState<DetailMarketScreen> {
  @override
  void initState() {
    Future.microtask(() =>
        ref.read(detailMarketNotifier.notifier).getDetail(widget.marketId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(detailMarketNotifier);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const AppBarSliver(title: "Detail Warung"),
          SliverList(
              delegate: SliverChildListDelegate([
            RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1), () {
                  ref
                      .read(detailMarketNotifier.notifier)
                      .getDetail(widget.marketId);
                });
              },
              child: Builder(builder: (_) {
                if (state.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_amber, size: 50),
                        Text(state.error!),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (state.data?.image == null)
                            ProfileWithName(state.data?.name ?? ".", radius: 30)
                          else
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage("$BASE/${state.data?.image}"),
                            ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ListTile(
                              title: const Text("Nama Warung",
                                  style: TextStyle(fontSize: 12)),
                              subtitle: Text(
                                state.data?.name ?? '-',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
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
                        value: state.data?.address?.vilage?.name,
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
                );
              }),
            )
          ]))
        ],
      ),
    );
  }
}
