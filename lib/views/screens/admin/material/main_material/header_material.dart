part of "../material.dart";

final isShowSearchProvider = StateProvider.autoDispose<bool>((ref) => false);

class HeaderMaterial extends ConsumerStatefulWidget {
  const HeaderMaterial({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeaderSuplayerState();
}

class _HeaderSuplayerState extends ConsumerState<HeaderMaterial> {
  late TextEditingController _searchCtrl;

  @override
  void initState() {
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
    final state = ref.watch(materialsNotifier);
    final isShowSearch = ref.watch(isShowSearchProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: FieldInput(
            hintText: "Cari Bahan Baku",
            controller: _searchCtrl,
            textValidator: "",
            keyboardType: TextInputType.text,
            obsecureText: false,
            isRounded: false,
            prefixIcons: const Icon(Icons.search),
            suffixIcon: isShowSearch
                ? IconButton(
                    onPressed: () {
                      _searchCtrl.clear();
                      FocusScope.of(context).unfocus();
                      ref.invalidate(isShowSearchProvider);
                      ref.invalidate(searchMaterialsNotifier);
                    },
                    icon: const Icon(Icons.close),
                  )
                : null,
            onTap: () {
              ref.read(isShowSearchProvider.notifier).state = true;
            },
            onChanged: (value) {
              ref.read(searchMaterialsNotifier.notifier).searchByQuery(
                    state.data as List<MaterialModel>,
                    query: value,
                  );
            },
          ),
        ),
        const Spacer(),
        if (state.isLoading)
          LoadingInButton(color: Theme.of(context).colorScheme.primary)
        else if (state.error != null)
          const Icon(Icons.warning, color: Colors.red),
        IconButton(
          onPressed: () {
            ref.read(materialsNotifier.notifier).getMaterials();
          },
          icon: const Icon(Icons.refresh),
        ),
        ElevatedButton.icon(
          onPressed: () =>
              nextPage(context, "${AppRoutes.admin}/material/form"),
          icon: const Icon(Icons.add),
          label: const Text("Tambah bahan baku"),
        )
      ],
    );
  }
}
