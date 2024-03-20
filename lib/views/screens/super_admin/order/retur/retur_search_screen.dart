import 'package:admin_hanaang/utils/extensions/date_formater.dart';
import 'package:admin_hanaang/views/components/empty_widget.dart';
import 'package:admin_hanaang/views/components/failure_widget.dart';
import 'package:admin_hanaang/views/components/loading_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/router/router_config.dart';
import '../../../../../config/theme.dart';
import '../../../../../features/retur/provider/retur_provider.dart';
import '../../../../../models/retur.dart';
import '../../../../components/navigation_widget.dart';

class ReturSearchScreen extends ConsumerStatefulWidget {
  const ReturSearchScreen({super.key});

  @override
  ConsumerState createState() => _ReturSearchScreenState();
}

class _ReturSearchScreenState extends ConsumerState<ReturSearchScreen> {
  late TextEditingController _searchCtrl;

  void _getData()=> ref.read(searchReturNotifier.notifier).search('');
  @override
  void initState() {
    _searchCtrl = TextEditingController();
    Future.microtask(() => _getData());
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchReturNotifier);
    final returData = state.data;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: TextFormField(
          controller: _searchCtrl,
          autofocus: true,
          cursorColor: Colors.black,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          onChanged: (value) {
            ref.read(searchReturNotifier.notifier).search(value);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          await Future.delayed(const Duration(seconds: 1),()=> _getData());
        },
        child: Builder(
          builder: (context) {
            if(state.isLoading){
              return const CircularLoading();
            }else if(state.error != null){
              return FailureWidget(error: state.error!, onPressed: ()=> _getData());
            }else if(state.data == null || state.data!.isEmpty){
              return const EmptyWidget();
            }
            return ListView.separated(
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (_, i) {
                Retur retur = returData[i];
                return Card(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  color: Theme.of(context).colorScheme.surface,
                  child: ListTile(
                    onTap: () => nextPage(context, "${AppRoutes.sa}/retur/detail",
                        argument: retur),
                    leading: const Icon(Icons.assignment_return_outlined),
                    title: Text(
                      retur.returNumber!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${retur.date!.timeFormat()} WIB",
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      "${retur.quantity} Cup",
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, i) => const SizedBox(height: 7),
              itemCount: returData!.length,
            );
          }
        ),
      ),
    );
  }
}

final searchRetur = StateNotifierProvider<SearchNotifier, List<Retur>>((ref) {
  return SearchNotifier();
});

class SearchNotifier extends StateNotifier<List<Retur>> {
  SearchNotifier() : super([]);

  searchByQuery(List<Retur> data, {required String query}) {
    List<Retur> temp = [];

    for (Retur retur in data) {
      if (retur.returNumber!.toLowerCase().contains(query.toLowerCase())) {
        temp.add(retur);
      }
    }
    state = temp;
  }
}
