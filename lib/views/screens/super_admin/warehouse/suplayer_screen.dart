import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme.dart';
import '../../../../features/suplayer/provider/suplayer_provider.dart';
import '../../../../utils/constant/base_url.dart';
import '../../../components/navigation_widget.dart';

class SuplayerScreen extends ConsumerStatefulWidget {
  const SuplayerScreen({super.key});

  @override
  ConsumerState createState() => _SuplayerScreenState();
}

class _SuplayerScreenState extends ConsumerState<SuplayerScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      ref.watch(suplayerNotifier.notifier).getSuplayer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(suplayerNotifier);
    final suplayerData = state.data;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Suplayer"),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1), () {
              ref.watch(suplayerNotifier.notifier).getSuplayer();
            });
          },
          child: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : suplayerData == null
                  ? const Center(
                      child: Text("Data tidak ditemukan"),
                    )
                  : ListView.separated(
                      padding:
                          const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 100.0),
                      itemCount: suplayerData.length,
                      itemBuilder: (_, i) {
                        final suplayer = suplayerData[i];
                        return Card(
                          color: Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            onTap: () {
                              nextPage(
                                  context, "${AppRoutes.sa}/suplayer/detail",
                                  argument: suplayer);
                            },
                            leading: suplayer.image == null
                                ? CircleAvatar(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    child: Text(
                                      suplayer.name![0],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        NetworkImage("$BASE/${suplayer.image}"),
                                  ),
                            title: Text("${suplayer.name}"),
                            subtitle: Text(
                              suplayer.phoneNumber!,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, i) {
                        return const SizedBox(height: 5);
                      },
                    )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => nextPage(context, "${AppRoutes.sa}/suplayer/form"),
        label: const Text(
          "Tambakan Suplayer",
          style: TextStyle(fontSize: 12),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
