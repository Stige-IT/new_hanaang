
part of "../splash.dart";
class TabletView extends ConsumerStatefulWidget {
  const TabletView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabletViewState();
}

class _TabletViewState extends ConsumerState<TabletView> {
  @override
  void initState() {
    Future.microtask(() => progressStream());
    super.initState();
  }

  void progressStream() {
    Timer.periodic(const Duration(milliseconds: 18), (timer) {
      ref.watch(percentProvider.notifier).state = (timer.tick / 100);
      if (timer.tick >= 100) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cover.png'),
                fit: BoxFit.fitWidth,
              )),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.all(35),
              width: 500,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StrokeText(
                    text: "Teh Tarik Hanaang",
                    strokeWidth: 10,
                    textStyle: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Setiap tegukan Teh Tarik Hanaang membawa Anda pada petualangan rasa yang tak terlupakan.",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: size.width * 0.5,
                child: LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  value: ref.watch(percentProvider),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Text(
                "${ref.watch(percentProvider)} %",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
