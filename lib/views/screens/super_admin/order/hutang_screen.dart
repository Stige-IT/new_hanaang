import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/features/hutang/provider/hutang_provider.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:admin_hanaang/views/components/profile_with_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/hutang.dart';

class HutangScreen extends ConsumerStatefulWidget {
  const HutangScreen({super.key});

  @override
  ConsumerState createState() => _HutangScreenState();
}

class _HutangScreenState extends ConsumerState<HutangScreen> {
  @override
  void initState() {
    Future.microtask(() => ref.watch(hutangNotifier.notifier).getHutang());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hutangNotifier);
    final dataHutang = state.data;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Daftar Hutang"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            ref.watch(hutangNotifier.notifier).getHutang();
          });
        },
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(child: Text(state.error!))
                : ListView.separated(
                    padding: const EdgeInsets.all(15.0),
                    itemBuilder: (_, i) {
                      Hutang? hutang = dataHutang![i];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        child: ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                          dense: true,
                          isThreeLine: true,
                          leading: ProfileWithName(hutang.name!),
                          title: Text(
                            hutang.name!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(hutang.email ?? "Email: -"),
                              Text(hutang.numberPhone ?? "No.Telepon: -"),
                            ],
                          ),
                          trailing: Text(
                            "${hutang.totalOrder}\nPesanan",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: ()=> nextPage(context, "${AppRoutes.sa}/hutang/detail", argument: hutang.id),
                        ),
                      );
                    },
                    separatorBuilder: (_, i) => const SizedBox(height: 7),
                    itemCount: dataHutang?.length ?? 0,
                  ),
      ),
    );
  }
}
