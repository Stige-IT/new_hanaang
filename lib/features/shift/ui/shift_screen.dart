part of "../shift.dart";

class ShiftScreen extends ConsumerStatefulWidget {
  const ShiftScreen({super.key});

  @override
  ConsumerState createState() => _ShiftScreenState();
}

class _ShiftScreenState extends ConsumerState<ShiftScreen> {
  Future<void> _getData() async {
    await ref.read(shiftNotifier.notifier).get();
  }

  @override
  void initState() {
    Future.microtask(() async {
      await _getData();
      final shiftData = ref.watch(shiftNotifier).data;
      log("shiftData: ${shiftData?.message} , status: ${shiftData?.status}");
      if (shiftData != null && shiftData.status!) {
        if (!mounted) return;
        nextPageRemoveAll(context, "/admin");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shiftNotifier);
    final dataShift = state.data;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(builder: (_) {
              if (state.isLoading) {
                return const Center(child: CircularLoading());
              } else if (state.error != null) {
                return Center(child: Text(state.error!));
              } else {
                return Column(
                  children: [
                    Image.asset("assets/components/logo_hanaang.png"),
                    const SizedBox(height: 25),
                    Text("🕛 Shift aktif dari : ${dataShift?.message}"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(openShiftNotifier.notifier)
                            .open()
                            .then((succes) {
                          if (succes) {
                            nextPageRemoveAll(context, "/admin");
                          } else {
                            final err = ref.watch(openShiftNotifier).error;
                            showSnackbar(context, err!, isWarning: true);
                          }
                        });
                      },
                      child: const Text("Buka Shift"),
                    ),
                    const SizedBox(height: 50.0),
                    TextButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.logout),
                      label: const Text("Keluar akun"),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "*Keluar akun akan sekaligus menutup shift saat ini.",
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
