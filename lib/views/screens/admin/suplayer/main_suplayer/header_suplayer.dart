part of "../suplayer.dart";

class HeaderSuplayer extends ConsumerStatefulWidget {
  const HeaderSuplayer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeaderSuplayerState();
}

class _HeaderSuplayerState extends ConsumerState<HeaderSuplayer> {
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
    final state = ref.watch(suplayerNotifier);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: FieldInput(
            hintText: "Cari Suplayer",
            controller: _searchCtrl,
            textValidator: "",
            keyboardType: TextInputType.text,
            obsecureText: false,
            isRounded: false,
            prefixIcons: const Icon(Icons.search),
          ),
        ),
        const Spacer(),
        if (state.isLoading)
          LoadingInButton(color: Theme.of(context).colorScheme.primary)
        else if (state.error != null)
          const Icon(Icons.warning, color: Colors.red),
        IconButton(
          onPressed: () {
            ref.read(suplayerNotifier.notifier).getSuplayer();
          },
          icon: const Icon(Icons.refresh),
        ),
        ElevatedButton.icon(
          onPressed: () => nextPage(context, "${AppRoutes.admin}/suplayer/form"),
          icon: const Icon(Icons.add),
          label: const Text("Tambah suplayer"),
        )
      ],
    );
  }
}
