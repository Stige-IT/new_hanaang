part of "../../reciep.dart";

class BottomSheetReciep extends ConsumerWidget {
  const BottomSheetReciep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataNotifier);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              PanaraConfirmDialog.show(
                context,
                message: "Yakin membuat resep baru ?",
                confirmButtonText: "Simpan",
                cancelButtonText: "kembali",
                onTapConfirm: () {
                  Navigator.of(context).pop();
                  ref
                      .read(createReciptNotifer.notifier)
                      .createRecipt(data)
                      .then((succes) {
                    if (succes) {
                      Navigator.of(context).pop();
                      showSnackbar(context, "Berhasil menambahkan resep");
                    } else {
                      final err = ref.watch(createMaterialNotifier).error;
                      showSnackbar(context, err!, isWarning: true);
                    }
                  });
                },
                onTapCancel: Navigator.of(context).pop,
                panaraDialogType: PanaraDialogType.warning,
              );
            },
            // },
            child: ref.watch(createReciptNotifer).isLoading
                ? const LoadingInButton()
                : const Text("Simpan"),
          )
        ],
      ),
    );
  }
}
