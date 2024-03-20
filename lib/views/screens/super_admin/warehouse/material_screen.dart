import 'package:admin_hanaang/config/router/router_config.dart';
import 'package:admin_hanaang/config/theme.dart';
import 'package:admin_hanaang/features/material/provider/material_provider.dart';
import 'package:admin_hanaang/views/components/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/material_model.dart';

class MaterialScreen extends ConsumerStatefulWidget {
  const MaterialScreen({super.key});

  @override
  ConsumerState createState() => _MaterialScreenState();
}

class _MaterialScreenState extends ConsumerState<MaterialScreen> {
  late TextEditingController _searchCtrl;

  _getData() async {
    ref.watch(materialsNotifier.notifier).getMaterials();
  }

  @override
  void initState() {
    _searchCtrl = TextEditingController();
    Future.microtask(() {
      _getData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(materialsNotifier);
    List<MaterialModel>? materials = state.data as List<MaterialModel>?;
    final isSearch = ref.watch(isShowSearch);
    final dataSearch = ref.watch(searchData);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: isSearch
            ? TextFormField(
                cursorColor: Colors.black,
                controller: _searchCtrl,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  ref
                      .watch(searchData.notifier)
                      .searchDataByName(materials ?? [], query: value);
                },
              )
            : const Text("Bahan Baku"),
        actions: [
          IconButton(
            onPressed: () {
              if (isSearch) {
                _searchCtrl.clear();
              }
              ref.watch(isShowSearch.notifier).changeVisibility(!isSearch);
            },
            icon: isSearch ? const Icon(Icons.close) : const Icon(Icons.search),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            _getData();
          });
        },
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
                ? Center(
                    child: Text(state.error!),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(15.0),
                    itemBuilder: (_, i) {
                      MaterialModel material =
                          isSearch ? dataSearch[i] : materials![i];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Theme.of(context).colorScheme.surface,
                        child: ListTile(
                          onTap: () => nextPage(
                              context, "${AppRoutes.sa}/material/detail",
                              argument: material.id),
                          title: Text(material.name!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          trailing: Text("${material.stock} ${material.unit}"),
                        ),
                      );
                    },
                    separatorBuilder: (_, i) => const SizedBox(height: 7),
                    itemCount:
                        isSearch ? dataSearch.length : materials?.length ?? 0,
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => nextPage(context, "${AppRoutes.sa}/material/create"),
        icon: const Icon(Icons.add),
        label: const Text("Tambah Bahan Baku"),
      ),
    );
  }
}

///[* visibilty search in appbar]
final isShowSearch = StateNotifierProvider<IsShowSearchNotifier, bool>(
    (ref) => IsShowSearchNotifier());

class IsShowSearchNotifier extends StateNotifier<bool> {
  IsShowSearchNotifier() : super(false);

  changeVisibility(bool newValue) => state = newValue;
}

///[* handle search data]
final searchData =
    StateNotifierProvider<SearchDataNotifier, List<MaterialModel>>((ref) {
  return SearchDataNotifier();
});

class SearchDataNotifier extends StateNotifier<List<MaterialModel>> {
  SearchDataNotifier() : super([]);

  searchDataByName(List<MaterialModel> data, {required String query}) {
    List<MaterialModel> temp = [];
    if (query.isNotEmpty) {
      for (MaterialModel material in data) {
        if (material.name!.toLowerCase().contains(query.toLowerCase())) {
          temp.add(material);
        }
      }
    } else {
      temp = data;
    }
    state = temp;
  }
}
